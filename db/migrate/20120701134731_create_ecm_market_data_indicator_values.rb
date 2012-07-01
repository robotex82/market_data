class CreateEcmMarketDataIndicatorValues < ActiveRecord::Migration
  def change
    create_table :ecm_market_data_indicator_values do |t|
      t.references :ecm_market_data_bar
      t.references :ecm_market_data_indicator
      t.text :inputs
      t.text :outputs

      t.timestamps
    end
    add_index :ecm_market_data_indicator_values, :ecm_market_data_bar_id
  end
end
