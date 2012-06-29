class Ecm::MarketData::TimeSeries < ActiveRecord::Base
  # associations
  belongs_to :ecm_market_data_provider, :class_name => 'Ecm::MarketData::Provider'
  belongs_to :ecm_market_data_instrument, :class_name => 'Ecm::MarketData::Instrument'
  belongs_to :ecm_market_data_resoution, :class_name => 'Ecm::MarketData::Resolution'
  
  has_many :ecm_market_data_bars, 
           :class_name  => 'Ecm::MarketData::Bar',
           :dependent   => :destroy,
           :foreign_key => 'ecm_market_data_time_series_id',
           :order => 'start_at ASC'

  
  # Attributes
  attr_accessible :description, :ecm_market_data_bars_count, :ecm_market_data_provider_id, :ecm_market_data_instrument_id, :ecm_market_data_resoution_id, :name
  
  # Validations
  validates :name, :presence => true, :uniqueness => { :scope => [ :ecm_market_data_provider_id, :ecm_market_data_instrument_id, :ecm_market_data_resoution_id ] }
end
