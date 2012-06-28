class CreateEcmMarketDataInstruments < ActiveRecord::Migration
  def change
    create_table :ecm_market_data_instruments do |t|
      t.string :name
      t.text :description
      t.integer :ecm_market_data_time_series_count

      t.timestamps
    end
    
    # Create a default instruments
    Ecm::MarketData::Instrument.create!(:name => 'DAX Index')
    Ecm::MarketData::Instrument.create!(:name => 'Euro Stoxx 50')
    Ecm::MarketData::Instrument.create!(:name => 'EUR/USD')
    Ecm::MarketData::Instrument.create!(:name => 'Euro Bund Future')
    Ecm::MarketData::Instrument.create!(:name => 'Apple Inc.')
  end
end
