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
    { :open => open, :high => high, :low => low, :close => close }
  end
  
  def next(limit = 1, column = :id)
    self.ecm_market_data_time_series.ecm_market_data_bars.where("#{column} > ?", send(column)).order(column).limit(limit)
  end  
  
  def self.last_week
    where("start_at >= :date", :date => 1.week.ago)
  end  
  
  def self.last_month
    where("start_at >= :date", :date => 1.month.ago)
  end    
  
  def self.last_year
    where("start_at >= :date", :date => 1.year.ago)
  end  
  
  def self.last_years(years)
    where("start_at >= :date", :date => years.year.ago)
  end  
  
  def self.starting_at(date)
    where("start_at >= :date", :date => date)
  end
  
  def self.up_to(date)
    where("start_at <= :date", :date => date)
  end  
end
