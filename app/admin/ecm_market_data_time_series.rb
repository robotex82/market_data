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
end
