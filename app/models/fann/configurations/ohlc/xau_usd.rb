class Fann::Configurations::OHLC::XauUsd < Fann::Configurations::Base
  # self.set_normalization_factor = 10000
  
  def prepare
    ts = self.data   
    bars = ts.ecm_market_data_bars.starting_at(2.years.ago).up_to(1.year.ago).map(&:to_ohlc)
    p "Loaded #{bars.size} bars "
    bars.each_with_index do |bar, index|
      next if index <= 2

      @inputs <<  [(bars[index-1][:open] * normalization_factor), (bars[index-1][:high] * normalization_factor), (bars[index-1][:low] * normalization_factor), (bars[index-1][:close] * normalization_factor)] 
      
      @desired_outputs << [bar[:close] * normalization_factor]
    end
  end
end
