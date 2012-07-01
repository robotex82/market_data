class Ecm::MarketData::TimeSeries < ActiveRecord::Base
  # associations
  belongs_to :ecm_market_data_provider, :class_name => 'Ecm::MarketData::Provider'
  belongs_to :ecm_market_data_instrument, :class_name => 'Ecm::MarketData::Instrument'
  belongs_to :ecm_market_data_resolution, :class_name => 'Ecm::MarketData::Resolution'
  
  has_many :ecm_market_data_bars, 
           :class_name  => 'Ecm::MarketData::Bar',
           :dependent   => :destroy,
           :foreign_key => 'ecm_market_data_time_series_id' # ,
           # :order => 'start_at ASC'

  
  # Attributes
  attr_accessible :description, :ecm_market_data_bars_count, :ecm_market_data_provider_id, :ecm_market_data_instrument_id, :ecm_market_data_resolution_id, :name
  
  # Validations
  validates :name, :presence => true, :uniqueness => { :scope => [ :ecm_market_data_provider_id, :ecm_market_data_instrument_id, :ecm_market_data_resolution_id ] }
  
  def display_name
    "#{provider_name} #{instrument_name} #{resolution_name}"
  end  
  
  def instrument_name
    ecm_market_data_instrument.name
  end  
  
  def resolution_name
    ecm_market_data_resolution.name
  end  
  
  def provider_name
    ecm_market_data_provider.name
  end    
  
  def self.load(provider_name, instrument_name, resolution_name)
    provider   = Ecm::MarketData::Provider.where(:name => provider_name).first
    instrument = Ecm::MarketData::Instrument.where(:name => instrument_name).first
    resolution = Ecm::MarketData::Resolution.where(:name => resolution_name).first
    where(:ecm_market_data_provider_id => provider).where(:ecm_market_data_instrument_id => instrument).where(:ecm_market_data_resolution_id => resolution).includes(:ecm_market_data_bars).first
  end
end
