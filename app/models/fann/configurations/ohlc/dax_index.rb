class Fann::Configurations::OHLC::DaxIndex < Fann::Configurations::Base
  def prepare
    ts = self.data   
#    ts.ecm_market_data_bars.offset(11).each do |bar|
#      @inputs <<  bar.previous(10).collect { |b| b.open / 10000 }
#      @desired_outputs << [bar.close / 10000]
#    end

    bars = ts.ecm_market_data_bars.starting_at(2.years.ago).up_to(1.year.ago).map(&:to_ohlc)
    p "Loaded #{bars.size} bars "
    bars.each_with_index do |bar, index|
      #next if index <= 10 or index >= 5010
      #next if index <= 4000 or index >= 5000
      next if index <= 2
      # @inputs <<  bars[index-11..index-1].collect { |b| b[:close] / 10000 }
      @inputs <<  [(bars[index-1][:open] * normalization_factor), (bars[index-1][:high] * normalization_factor), (bars[index-1][:low] * normalization_factor), (bars[index-1][:close] * normalization_factor)] 
      
      @desired_outputs << [bar[:close] * normalization_factor]
    end
  end
end
