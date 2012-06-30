require 'ruby_fann/neural_network'

# Base class to store and train ANNs 
# 
# USAGE:
# * Inherit from it and implement prepare to prepare your training data.
# 
# Then prepare, train, save, load and run
class Fann::Configurations::Base
  attr_accessor :desired_outputs
  attr_accessor :inputs
  attr_accessor :data
  
  attr_accessor :num_inputs
  attr_accessor :num_outputs
  
  attr_accessor :fann 
  attr_accessor :hidden_neurons 
  
  # input and output values are multiplied with the normalization factor to
  # get numbers between 1 and -1 for fann processing
  attr_accessor :normalization_factor
  
  def initialize(data, inputs_count, outputs_count, hidden_neurons, normalization_factor = 1)
    @data = data
    @num_inputs = inputs_count
    @num_outputs = outputs_count
    
    @desired_outputs = []
    @inputs = []
    @hidden_neurons = hidden_neurons 
    
    @normalization_factor = normalization_factor
    
    init_fann
  end
  
  def init_fann
    @fann = RubyFann::Standard.new(
      :num_inputs => @num_inputs, 
      :hidden_neurons => @hidden_neurons, 
      :num_outputs => @num_outputs)
  end
  
  def load
    fann = RubyFann::Standard.new( :filename => "#{Rails.root}/data/#{self.class.to_s.tableize.singularize}.conf" )
  end
  
  # The prepare method prepares training data.
  def prepare(options = {})
    raise "prepare not implemented"
  end
  
  # Trains the ANN with the training data (Don't forget to call prepare first)
  # The desired error is divided by the normalizaion factor to respect data 
  # normalization.
  def train(options = {})
    options.reverse_merge!({ :max_epochs => 100000, :epochs_between_reports => 500, :desired_error => 0.0001 })
    #fann.train_on_data(train_data, 10000, 100, 0.00001)
    fann.train_on_data(train_data, options[:max_epochs], options[:epochs_between_reports], options[:desired_error] * normalization_factor)
  end
  
  # Re-inits the ANN and forgets learned stuff
  def reset 
    init_fann
  end
  
  # Runs fann on real inputs
  def run(inputs, normalize_outputs = true)
    outputs = fann.run(inputs)
    if normalize_outputs
      return outputs.map { |value| value / normalization_factor }
    else
      return outputs
    end  
  end  
  
  # Saves the fann config to a file
  def save
    fann.save("#{Rails.root}/data/#{self.class.to_s.tableize.singularize}.conf")
  end
  
  private
    # Creates a train data object
    def train_data
      ::RubyFann::TrainData.new(
        :inputs => inputs, 
        :desired_outputs=> desired_outputs)
    end
end
