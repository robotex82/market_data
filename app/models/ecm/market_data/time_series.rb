class Ecm::MarketData::TimeSeries < ActiveRecord::Base
  belongs_to :ecm_market_data_provider
  belongs_to :ecm_market_data_resoution
  attr_accessible :description, :name
end
