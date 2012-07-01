class Ecm::MarketData::Bar < ActiveRecord::Base
  # associations
  belongs_to :ecm_market_data_time_series, 
             :class_name => 'Ecm::MarketData::TimeSeries', 
             :counter_cache => 'ecm_market_data_bars_count'
             # :include => [ :ecm_market_data_time_series ]
             
  has_many :ecm_market_data_indicator_values,
           :class_name => 'Ecm::MarketData::IndicatorValue',
           :dependent   => :destroy,
           :foreign_key => 'ecm_market_data_bar_id',
           :order => 'name ASC'                        
  
  # attributes           
  attr_accessible :close, :high, :low, :open, :start_at, :volume
  
  # default scope
  #default_scope :order => 'start_at ASC'
  
  # instance methods
  def display_name 
    to_s
  end
  
  def next(limit = 1, column = :start_at, direction = :desc)
    self.ecm_market_data_time_series.ecm_market_data_bars.where("#{column} > ?", send(column)).order("#{column} #{direction.to_s.upcase}").limit(limit)
  end
  
  def next_including_self(limit = 1, column = :start_at, direction = :desc)
    self.ecm_market_data_time_series.ecm_market_data_bars.where("#{column} >= ?", send(column)).order("#{column} #{direction.to_s.upcase}").limit(limit)
  end
  
  def previous(limit = 1, column = :start_at, direction = :desc)
    self.ecm_market_data_time_series.ecm_market_data_bars.where("#{column} < ?", send(column)).order("#{column} #{direction.to_s.upcase}").limit(limit)
  end  
  
  def previous_including_self(limit = 1, column = :start_at, direction = :desc)
    self.ecm_market_data_time_series.ecm_market_data_bars.where("#{column} <= ?", send(column)).order("#{column} #{direction.to_s.upcase}").limit(limit)
  end
  
  def to_ohlc
    { :open => open, :high => high, :low => low, :close => close }
  end
  
  def to_s
    "#{ecm_market_data_time_series.display_name} #{start_at}"  
  end
  
  # class methods
  
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
