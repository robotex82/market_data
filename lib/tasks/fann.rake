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
  
  desc 'trains on dax data'
  task :train_test, [] => :environment do
    # Load time series
    ts = Ecm::MarketData::TimeSeries.load("Dukascopy", "EUR/USD", "1 Day")
    
    # create new fan configuration
    fc = Fann::Configurations::OHLC::EurUsd.new(ts, 4, 1, [ 20, 20, 20 ], 0.1)

    # prepare test data (previous last year)
    fc.prepare
    
    # Training using data created above:
    fc.train

    # save neuron config to file    
    fc.save

    # load last year real data
    bars = ts.ecm_market_data_bars.last_year.map(&:to_ohlc)
    # init stats
    guesses = { :total => 0, :correct => 0, :wrong => 0 }
    
    # process real data
    bars.each_with_index do |bar, index|
      next if index <= 1
      inputs = [(bars[index-1][:open] * fc.normalization_factor), (bars[index-1][:high]* fc.normalization_factor), (bars[index-1][:low] * fc.normalization_factor), (bars[index-1][:close] * fc.normalization_factor)]
      should_output = bar[:close]
      output = fc.run(inputs)

      p "o: #{bar[:open]}"
      p "h: #{bar[:high]}"
      p "l: #{bar[:low]}"
      p "c: #{bar[:close]}"      
      p "gc: #{output.first / fc.normalization_factor}"
      p "diff: #{((output.first / fc.normalization_factor) - should_output)}"
      
      if bar[:open] < bar[:close]
        p "Should: buy"
      else
        p "Should: sell"      
      end  
      
      if bar[:open] < (output.first / fc.normalization_factor)
        p "Guessed: buy"
      else
        p "Guessed: sell"      
      end  
      p "================================================================================"  
      
      if (bar[:open] < bar[:close] && bar[:open] < (output.first / fc.normalization_factor)) || bar[:open] > bar[:close] && bar[:open] > (output.first / fc.normalization_factor)
        guesses[:correct] += 1
      else
        guesses[:wrong] += 1
      end  
      guesses[:total] += 1
    end
    # output stats
    guesses.each { |k, v| p "#{k}: #{v}" }
  end
end
