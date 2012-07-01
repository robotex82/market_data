require 'ruby_fann/neural_network'

namespace :fann do
  desc 'runs the fann example'
  task :example, [] => :environment do
  # task :example, [:argument] => :environment do
    # Create Training data with 2 each of inputs(array of 3) & desired outputs(array of 1).
    training_data = RubyFann::TrainData.new(
      :inputs=>[[0.3, 0.4, 0.5], [0.1, 0.2, 0.3]], 
      :desired_outputs=>[[0.7], [0.8]])

    # Create FANN Neural Network to match appropriate training data:
    fann = RubyFann::Standard.new(
      :num_inputs=>3, 
      :hidden_neurons=>[2, 8, 4, 3, 4], 
      :num_outputs=>1)

    # Training using data created above:
    fann.train_on_data(training_data, 1000, 1, 0.1)

    # Run with different input data:
    outputs = fann.run([0.7, 0.9, 0.2])   
  end
  
  desc 'Tries to guess last year'
  task :train_test, [] => :environment do
    lookback = 10
    offset = 10
  
    # Load time series
    ts = Ecm::MarketData::TimeSeries.load("Dukascopy", "EUR/USD", "1 Day")
    
    # create new fan configuration
    #fc = Fann::Configurations::OHLC::EurUsd.new(ts, 10, 1, [ 20, 20, 20 ], 0.1)
    fc = Fann::Configurations::OHLC::EurUsd.new(ts, 10, 1, [ 7 ], 0.1)

    # prepare test data (previous last year)
    fc.prepare(:lookback => lookback, :offset => offset)
    
    # Training using data created above:
    fc.train(:max_epochs => 5000, :epochs_between_reports => 1000, :desired_error => 0.000001)

    # save neuron config to file    
    fc.save



    
    # process real data
    
    # init stats
    stats = { :total => 0, :correct => 0, :wrong => 0 }
    
    # load previous last year bars form time series and transform them to a ohlc hash
    bars = ts.ecm_market_data_bars.starting_at(1.year.ago).map(&:to_ohlc)
    p "Loaded #{bars.size} bars "
    
    # loop over bars

    bars.each_with_index do |bar, index|
      # skip n bars as we need a lookback
      next if index < (lookback + offset)

      
      input_data = []
      lookback.times do |lookback|  
        # get previous bar as input
        previous_bar = bars[index - (lookback + offset) - 1 ]   
        
        # normalize values for fann input
        previous_bar.map { |value| value * fc.normalization_factor }  
        
        # Add previous bar ohlc data as input for fann
        input_data << previous_bar[:close] 
#        input_data << previous_bar[:open] 
#        input_data << previous_bar[:high]             
#        input_data << previous_bar[:low] 
#        input_data << previous_bar[:close] 
      end
      # Add previous bar ohlc data as input for fann
      fann_output = fc.run( input_data )
      
      # Use actual bar close as desired output for fann
      desired_output = bar[:close]
      
#      p "Open:  #{"%.4f" % bar[:open]}"       
#      p "Close: #{"%.4f" % bar[:close]}"       
#      p "Guess: #{"%.4f" % fann_output.first}"
#      p "================================================================================"
      p "#{"%.4f" % bar[:close]};#{"%.4f" % fann_output.first}".gsub(".",",")
      
      stats[:total] += 1
      if (bar[:open] < bar[:close] && bar[:open] < fann_output.first) || (bar[:open] > bar[:close] && bar[:open] > fann_output.first)
        stats[:correct] += 1
      else
        stats[:wrong] += 1      
      end  
    end  
    p stats.inspect
  end
end
