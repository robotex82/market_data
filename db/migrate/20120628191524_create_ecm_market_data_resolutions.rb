class CreateEcmMarketDataResolutions < ActiveRecord::Migration
  def change
    create_table :ecm_market_data_resolutions do |t|
      t.string :name
      t.text :description
      t.integer :ecm_market_data_time_series_count

      t.timestamps
    end
    
    # Create a default resolutions
    Ecm::MarketData::Resolution.create!(:name => '1 Minute')
    Ecm::MarketData::Resolution.create!(:name => '5 Minutes')
    Ecm::MarketData::Resolution.create!(:name => '10 Minutes')
    Ecm::MarketData::Resolution.create!(:name => '15 Minutes')
    Ecm::MarketData::Resolution.create!(:name => '15 Minutes')
    Ecm::MarketData::Resolution.create!(:name => '30 Minutes')
    Ecm::MarketData::Resolution.create!(:name => '60 Minutes')
    Ecm::MarketData::Resolution.create!(:name => '1 Day')
    Ecm::MarketData::Resolution.create!(:name => '1 Week')
    Ecm::MarketData::Resolution.create!(:name => '1 Month')
  end
end
