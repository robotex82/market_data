class CreateEcmMarketDataProviders < ActiveRecord::Migration
  def change
    create_table :ecm_market_data_providers do |t|
      t.string :name
      t.text :description
      t.integer :ecm_market_data_time_series_count

      t.timestamps
    end
    
    # Create a default data providers
    Ecm::MarketData::Provider.create!(:name => 'Dukascopy')
  end
end
