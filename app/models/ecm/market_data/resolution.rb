class Ecm::MarketData::Resolution < ActiveRecord::Base
  attr_accessible :description, :ecm_market_data_time_series_count, :name
end
