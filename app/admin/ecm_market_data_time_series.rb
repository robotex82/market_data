ActiveAdmin.register Ecm::MarketData::TimeSeries do
  index do
    selectable_column
    id_column
    column :ecm_market_data_provider
    column :ecm_market_data_instrument
    column :ecm_market_data_resolution
    column :name
    column :description
    column :created_at
    column :updated_at    
    default_actions
  end
  
  show do
    attributes_table do
      row :id
      row :name
      row :description
      row :ecm_market_data_bars_count
      row :ecm_market_data_provider
      row :ecm_market_data_instrument
      row :ecm_market_data_resolution
      row :created_at
      row :updated_at
    end
    
    query = ecm_market_data_time_series.ecm_market_data_bars
    query = query.where('start_at >= ?', params[:begin]) if params[:begin]
    query = query.where('start_at <= ?', params[:end]) if params[:end]      
    bars = query.page(params[:page]).per(365) 
    
    panel :months do
      para do
        ecm_market_data_time_series.ecm_market_data_bars.only(:start_at).map {|ts| ts.start_at.to_date.beginning_of_month}.uniq.sort.collect do |m|
          link_to_unless_current m.strftime('%m.%Y'), :begin => m.beginning_of_day, :end => m.end_of_month.end_of_day
        end.join(" ").html_safe
      end
    end
    
    panel :candlesticks do   
      data_table = GoogleVisualr::DataTable.new
      data_table.new_column('string', 'day')
      data_table.new_column('number', 'low')
      data_table.new_column('number', 'open')
      data_table.new_column('number', 'close')
      data_table.new_column('number', 'high')
      data_table.add_rows bars.collect { |bar| [bar.start_at.to_s, bar.low, bar.open, bar.close, bar.high] }

      #opts = { :width => 1500, :height => 600, :legend => 'none', :candlestick => { :hollowIsRising => false, :fallingColor => { :fill => '#FF0000', :stroke => '#000000'}, :risingColor => { :fill => '#00FF00', :stroke => '#000000'}  } }
      opts = { :width => 1500, :height => 600, :legend => 'none' }
      @chart = GoogleVisualr::Interactive::CandlestickChart.new(data_table, opts)   
      

      div :id => 'chart' do
        render_chart(@chart, 'chart')     
      end
      para do
        paginate bars      
      end
    end
  end
end
