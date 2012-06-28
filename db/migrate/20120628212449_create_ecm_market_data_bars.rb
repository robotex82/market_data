class CreateEcmMarketDataBars < ActiveRecord::Migration
  def change
    create_table :ecm_market_data_bars do |t|
      t.timestamp :start_at
      t.integer :volume
      t.float :open
      t.float :high
      t.float :low
      t.float :close
      t.references :ecm_market_data_time_series

      t.timestamps
    end
    add_index :ecm_market_data_bars, :ecm_market_data_time_series_id
  end
end
