class Fann::Configurations::OHLC::EurUsd < Fann::Configurations::Base
  def prepare(options = {})
    options.reverse_merge!({ :lookback => 1 })
  
    # @data is a Ecm::MarketData::TimeSeries
    ts = self.data   
    
    # load previous last year bars form time series and transform them to a ohlc hash
    bars = ts.ecm_market_data_bars.starting_at(2.years.ago).up_to(1.year.ago).map(&:to_ohlc)
    p "Loaded #{bars.size} bars "
    
    # loop over bars
    bars.each_with_index do |bar, index|
      # skip n bars as we need a lookback
      next if index < options[:lookback]

      
      input_data = []
      options[:lookback].times do |lookback|  
        # get previous bar as input
        previous_bar = bars[index - lookback - 1 ]   
        
        # normalize values for fann input
        previous_bar.map { |value| value * normalization_factor }  
        
        
        input_data << previous_bar[:close]
#        # Add previous bar ohlc data as input for fann
#        input_data << previous_bar[:open] 
#        input_data << previous_bar[:high]             
#        input_data << previous_bar[:low] 
#        input_data << previous_bar[:close] 
      end
      # Add previous bar ohlc data as input for fann
      @inputs <<  input_data
      
      # Use actual bar close as desired output for fann
      @desired_outputs << [bar[:close] * normalization_factor]        
      
#      # skip n bars as we need a lookback
#      next if index < options[:lookback]
#      
#      # get previous bar as input
#      previous_bar = bars[index-1]
#      
#      # normalize values for fann input
#      previous_bar.map { |value| value * normalization_factor }
#      
#      # Add previous bar ohlc data as input for fann
#      @inputs <<  [ previous_bar[:open], previous_bar[:high], previous_bar[:low], previous_bar[:close] ] 
#      #@inputs <<  [(previous_bar[:open] * normalization_factor), (previous_bar[:high] * normalization_factor), (previous_bar[:low] * normalization_factor), (previous_bar[:close] * normalization_factor)] 
#      
#      # Use actual bar close as desired output for fann
#      @desired_outputs << [bar[:close] * normalization_factor]
    end
  end
end
