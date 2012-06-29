class Ecm::MarketData::Bar < ActiveRecord::Base
  # associations
  belongs_to :ecm_market_data_time_series, 
             :class_name => 'Ecm::MarketData::TimeSeries', 
             :counter_cache => 'ecm_market_data_bars_count'
  
  # attributes           
  attr_accessible :close, :high, :low, :open, :start_at, :volume
  
  def previous(limit = 1, column = :id)
    self.ecm_market_data_time_series.ecm_market_data_bars.where("#{column} < ?", send(column)).order(column).limit(limit)
  end
  
  def to_ohlc
    [open, high, low, close]
  end
  
  def next(limit = 1, column = :id)
    self.ecm_market_data_time_series.ecm_market_data_bars.where("#{column} > ?", send(column)).order(column).limit(limit)
  end  
end
