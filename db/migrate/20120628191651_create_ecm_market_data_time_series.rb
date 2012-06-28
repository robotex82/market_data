class CreateEcmMarketDataTimeSeries < ActiveRecord::Migration
  def change
    create_table :ecm_market_data_time_series do |t|
      t.string :name
      t.text :description
      t.integer :ecm_market_data_bars_count
      t.references :ecm_market_data_provider
      t.references :ecm_market_data_instrument
      t.references :ecm_market_data_resoution

      t.timestamps
    end
    # add_index :ecm_market_data_time_series, :ecm_market_data_provider_id
    # add_index :ecm_market_data_time_series, :ecm_market_data_resoution_id
  end
end
