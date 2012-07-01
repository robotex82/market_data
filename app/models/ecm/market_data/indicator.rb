class Ecm::MarketData::Indicator < ActiveRecord::Base
  # associations
  has_many :ecm_market_data_indicator_values,
           :class_name => 'Ecm::MarketData::IndicatorValue',
           :dependent   => :destroy,
           :foreign_key => 'ecm_market_data_indicator_id'             
  
  # attribautes
  attr_accessible :ecm_market_data_indicator_values_count, :default_inputs, :name
  
  # validations
  validates :default_inputs, :presence => true  
  validates :name, :presence => true, :uniqueness => true, :inclusion => ::Indicator::Base.descendants.map { |c| c.to_s.demodulize }
end
