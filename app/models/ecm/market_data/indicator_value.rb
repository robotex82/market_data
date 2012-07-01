class Ecm::MarketData::IndicatorValue < ActiveRecord::Base
  # associations
  belongs_to :ecm_market_data_bar,
             :class_name => 'Ecm::MarketData::Bar', 
             :counter_cache => 'ecm_market_data_indicator_values_count'
             
  belongs_to :ecm_market_data_indicator,
             :class_name => 'Ecm::MarketData::Indicator', 
             :counter_cache => 'ecm_market_data_indicator_values_count'
  
  # attributes
  attr_accessible :ecm_market_data_indicator_id, :inputs, :outputs
  
  # serialized attributes
  serialize :inputs, Hash
  serialize :outputs, Hash  
  
  # validations
  validates :ecm_market_data_bar_id, :presence => true 
  validates :ecm_market_data_indicator_id, :presence => true  
  validates :inputs, :presence => true, :uniqueness => { :scope => [ :ecm_market_data_bar_id, :ecm_market_data_indicator_id ] }
  validates :outputs, :presence => true
end
