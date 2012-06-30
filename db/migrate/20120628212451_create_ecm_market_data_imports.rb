class CreateEcmMarketDataImports < ActiveRecord::Migration
  def change
    create_table :ecm_market_data_imports do |t|
      t.references :ecm_market_data_time_series
      t.string :data_file_name
      t.integer :data_file_size
      t.string :data_content_type
      t.timestamp :data_updated_at
      t.string :data_fingerprint

      t.timestamps
    end
    # add_index :ecm_market_data_imports, :ecm_market_data_time_series_id
  end
end
