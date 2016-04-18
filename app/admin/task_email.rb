ActiveAdmin.register TaskEmail do
  belongs_to :task

  menu false

  permit_params :title, :description, :task_id, :reciever_id, :sender_id

  navigation_menu :default

  config.breadcrumb = false
  
  actions :all, except: [:destroy, :edit]

  action_item :back, only: :show do
    link_to 'Atpakaļ', request.referer
  end

  controller do
  	def create
  		create!{admin_task_path( Task.find(params[:task_id])) }
  	end
  end
  form do |f|
    f.inputs do
      f.input :title, label: 'Virsraksts'
      f.input :description, as: :text, label: 'Saturs'
      f.input :reciever_id, as: :select, collection: options_for_select(AdminUser.all.map {|u| ["#{u.email}", u.id] }, params[:reciever_id]), include_blank: false, label: 'Saņēmējs'
      # f.input :reciever_id, input_html: {value: 999}
      f.input :sender_id, as: :hidden, input_html: {value: current_admin_user.id||params[:sender_id]}, label: 'Sūtītājs'
    end
    f.actions
  end
  show do 
    panel 'Ziņojums' do
      div class: 'text_display' do 
        simple_format task_email.description
      end
    end
  end

  sidebar 'Informācija par ziņojumu', only: :show, if: proc {can? :manage, AdminUser} do
    attributes_table_for task_email do
      row 'Virsraksts' do |te| te.title end
      row 'Sūtītājs' do |te| "#{AdminUser.find(te.sender_id).full_name} <#{AdminUser.find(te.sender_id).email}>" end
      row 'Nosūtīts' do |te| te.created_at end
    end
  end
end
