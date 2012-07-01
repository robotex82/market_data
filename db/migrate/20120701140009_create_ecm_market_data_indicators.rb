class CreateEcmMarketDataIndicators < ActiveRecord::Migration
  def change
    create_table :ecm_market_data_indicators do |t|
      t.string :name
      t.text :default_inputs
      t.integer :ecm_market_data_indicator_values_count

      t.timestamps
    end

    Ecm::MarketData::Indicator.create! :name => 'Atr',  :default_inputs => { :time_period => 14 }
    Ecm::MarketData::Indicator.create! :name => 'Ema',  :default_inputs => { :time_period => 14 }
    Ecm::MarketData::Indicator.create! :name => 'Macd', :default_inputs => { :fast_period => 12, 
                                                                             :slow_period => 26, 
                                                                             :signal_period => 9 }
    Ecm::MarketData::Indicator.create! :name => 'Sma',  :default_inputs => { :time_period => 14 }
  end
end
