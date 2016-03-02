#encoding: utf-8
ActiveAdmin.register Setting do
  menu :parent => "Administrācija", :label => "Uzstādījumi" 


  filter :name, :label => "Nosaukums"
  filter :value, :label => "Vērtība"
  filter :description, :label => "Apraksts"
  filter :created_at, :label =>  "Izveidots"

  config.clear_action_items! 

  actions :show,:edit,:index,:update

  form do |f|
    f.inputs "Uzstādījumi" do
      f.input :value, :as => :text, :label => "Vērtība"
      f.input :description,:input_html => {:disabled => true}, :label => "Nosaukums"
    end
    f.actions do  
      f.action :submit, :as => :input , :label => "Saglabāt"
      f.action :cancel, :wrapper_html => { :class => "Atcelt" }, :label => "Atcelt"
    end  
  end

  index :title => proc{"Uzstādījumi"} do
    column :id
    column "Nosaukums" do |setting| setting.description end
    column "Vērtība" do |setting| setting.value end
   actions
  end


  show :title => proc{"Uzstādījumi"} do |ad|
    attributes_table do
      row "name:" do ad.description end
      row "value:" do ad.value end
      row "created_at:" do ad.created_at end
      row "updated_at:" do ad.updated_at end
    end

  end

  controller do
    def update
      @obj = Setting.find(params[:id])
      @obj.update_attributes(setting_params)
      redirect_to admin_settings_path
    end 

    private

    def setting_params
      params.require(:setting).permit(:name, :value, :description, :created_at, :updated_at)
    end
  end  

end
