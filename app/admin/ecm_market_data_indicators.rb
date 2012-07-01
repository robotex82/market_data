ActiveAdmin.register Ecm::MarketData::Indicator do
  form do |f|
    f.inputs do
      f.input :name, :as => :select, :collection => ::Indicator::Base.descendants.map { |c| c.to_s.demodulize }.sort
      f.input :default_inputs
    end
    
    f.actions
  end
end
