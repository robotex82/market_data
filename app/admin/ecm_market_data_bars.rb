ActiveAdmin.register Ecm::MarketData::Bar do
  show do
    attributes_table do
      row :id
      row :start_at
      row :volume
      row :open
      row :high
      row :low
      row :close
      row :ecm_market_data_time_series
      row :created_at
      row :updated_at
    end
    
    panel :candlestick do
      data_table = GoogleVisualr::DataTable.new
      data_table.new_column('string', 'day')
      data_table.new_column('number', 'low')
      data_table.new_column('number', 'open')
      data_table.new_column('number', 'close')
      data_table.new_column('number', 'high')
      data_table.add_rows( [
        [ecm_market_data_bar.start_at.to_s, ecm_market_data_bar.low, ecm_market_data_bar.open, ecm_market_data_bar.close, ecm_market_data_bar.high]
      ] )

      opts = { :width => 400, :height => 240, :legend => 'none' }
      @chart = GoogleVisualr::Interactive::CandlestickChart.new(data_table, opts)   
      
      div :id => 'chart' do
        render_chart(@chart, 'chart')
      end
    end
  end
end
