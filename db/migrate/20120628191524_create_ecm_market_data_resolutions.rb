class CreateEcmMarketDataResolutions < ActiveRecord::Migration
  def change
    create_table :ecm_market_data_resolutions do |t|
      t.string :name
      t.text :description
      t.integer :ecm_market_data_time_series_count

      t.timestamps
    end
  end
end
