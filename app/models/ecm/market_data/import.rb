class Ecm::MarketData::Import < ActiveRecord::Base
  belongs_to :ecm_market_data_time_series, :class_name => 'Ecm::MarketData::TimeSeries'
  
  # attributes
  # attr_accessible :data_content_type, :data_file_name, :data_file_size, :data_image_fingerprint, :data_updated_at, :ecm_market_data_time_series_id
  attr_accessible :data, :ecm_market_data_time_series_id
  
  # paperclip
  has_attached_file :data
  
  # validations
  validates :ecm_market_data_time_series, :presence => true
  
  def import!
    provider = self.ecm_market_data_time_series.ecm_market_data_provider
    import_class = Ecm::MarketData::Import.import_class_name_for_provider(provider)
    importer = import_class.new(data.path)
    importer.parse.each do |bar|
      self.ecm_market_data_time_series.ecm_market_data_bars.create!(bar)
    end

#    File.open("users.txt", "r").each do |line|
#      name, age, profession = line.strip.split("\t")
#      u = User.new(:name => name, :age => age, :profession => profession)
#      u.save
#    end
  end  
  
  def self.import_class_name_for_provider(provider)
    "::Ecm::MarketData::Import::#{provider.name.tableize.classify}".constantize
  end
  
  class Dukascopy
    require 'csv'
    
    attr_accessor :data_file_name
    
    def initialize(data_file_name)
      self.data_file_name = data_file_name
    end  
    
    def parse
      data = []
      ::CSV.foreach(data_file_name, :col_sep => ";") do |row|
        # next if row[0] == "DATE" or row[0] == " "
        timestamp_string = "#{row[0]} #{row[1]}"
        #timestamp = Time.strptime(timestamp_string, '%d-%m-%Y %H:%M:%S')
        #p timestamp_string
        timestamp = DateTime.strptime(timestamp_string, "%m/%d/%Y %H:%M:%S") rescue next
        row[2..7].each do |element|
          element.gsub!(',', '.').to_f
        end

        volume = row[2]
        open = row[3]
        high = row[4]
        low = row[5]
        close = row[6]
        data << { :start_at => timestamp, :volume => volume, :open => open, :high => high, :low => low, :close => close }
      end
      return data
    end
  end
end
