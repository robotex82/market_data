ActiveAdmin.register Ecm::MarketData::IndicatorValue do
  form do |f|
    f.inputs do
      f.input :ecm_market_data_bar, :as => :select, :collection => Ecm::MarketData::Bar.includes(:ecm_market_data_time_series).collect { |bar| [ bar, bar.id ] }    
      f.input :ecm_market_data_indicator
      f.input :inputs      
      f.input :outputs      
    end
    
    f.buttons
  end
end
