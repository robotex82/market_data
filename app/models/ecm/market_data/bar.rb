class Ecm::MarketData::Bar < ActiveRecord::Base
  belongs_to :ecm_market_data_time_series, :class_name => 'Ecm::MarketData::TimeSeries'
  attr_accessible :close, :high, :low, :open, :start_at, :volume
end
