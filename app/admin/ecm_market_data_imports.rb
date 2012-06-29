if defined?(ActiveAdmin)
  ActiveAdmin.register Ecm::MarketData::Import do
    action_item :only => :show do
      link_to "Import", import_admin_ecm_market_data_import_path(ecm_market_data_import), :method => :put
    end
    
    form :html => { :enctype => "multipart/form-data" } do |f|
      f.inputs do
        f.input :ecm_market_data_time_series
        f.input :data, :as => :file
      end
      
      f.buttons
    end    
    
    member_action :import, :method => :put do
      import = Ecm::MarketData::Import.find(params[:id])
      if import.import!
        redirect_to( {:action => :show}, :notice => "Imported!")
      else
        redirect_to( {:action => :show}, :notice => "Failed to import!" )     
      end  
    end
  end
end
