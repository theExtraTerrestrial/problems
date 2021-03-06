ActiveAdmin.register Task do
  ActiveAdmin.register TaskImage do
    belongs_to :task

    menu false

    controller do
      def destroy
        @task_image = TaskImage.find(params[:id])
        @task = @task_image.task
        @task_image.destroy
        flash[:success] = 'Pielikums veiksmīgi dzēsts'
        redirect_to admin_task_path(@task)
      end
    end
  end

  ActiveAdmin.register TaskLog do
    belongs_to :task

    permit_params :time, :description, :id

    controller do
      def create
        create!{admin_task_path( Task.find(params[:task_id])) }
      end
    end
  end
  
  menu label: 'Pieteikumi'

  permit_params :name, :description, :admin_deadline, :employee_deadline, :state, :company_id,
    :category_id, :creator_id, :responsible_id, :admin_priority, :user_priority, :admin_user_id,
    task_images_attributes: [:id, :name, :description, :image, :_destroy],
    task_logs_attributes: [:id, :time, :description, :task_id, :_destroy],
    task_emails_attributes: [:title, :description, :task_id, :reciever_id, :sender_id, :id, :_destroy]

  before_build do |record|
    record.creator_id = current_admin_user.id
    record.admin_user_id = current_admin_user.id
    record.state = 1
    record.company_id = current_admin_user.company.id unless can? :manage, AdminUser
  end
  
  after_create do |record|
    unless (request.xhr?)||(can? :manage, AdminUser)
      if (record.employee_deadline)&&(record.employee_deadline < Time.now)
        flash[:error] = "Atpakaļ ejoši datumi nav atļauti."
        redirect_to new_admin_task_path
      end
    end
  end



  member_action :close, method: :get do 
    session[:return_to] ||= request.referer
    if resource.closed_by_admin || resource.closed_by_employee
      if can? :manage, AdminUser
        resource.update_attribute('closed_by_admin', false)
        resource.update_attribute('state', 1)
      else
        resource.update_attribute('closed_by_employee', false)
        resource.update_attribute('state', 1)
      end
      redirect_to session.delete(:return_to), notice: "Pieteikuma atcelšana ir atsaukta"
    else
      if can? :manage, AdminUser
        resource.update_attribute('closed_by_admin', true)
        resource.update_attribute('state', 3)
      else
        resource.update_attribute('closed_by_employee', true)
        resource.update_attribute('state', 3)
      end
      redirect_to session.delete(:return_to), notice: "Pieteikums ir atcelts"
    end
  end

  action_item :new_email, only: :show, if: proc {can? :manage, AdminUser} do
    link_to 'Nosūtīt ziņojumu', new_admin_task_task_email_path(task_id: task.id, reciever_id: task.admin_user.id, sender_id: current_admin_user.id)
  end

  
  filter :name, as: :string, label: 'Temats'
  filter :state, as: :select, label: 'Stāvoklis', collection: Task::STATUS.each{|k,v| [k,v] }
  filter :company, label: 'Uzņēmums', if: proc {can? :manage, AdminUser}
  filter :category, label: 'Kategorija'
  filter :creator_id, as: :select, label: 'Izveidotājs', if: proc {can? :manage, AdminUser}, collection: -> {AdminUser.all.map(&:full_name)} if ActiveRecord::Base.connection.table_exists? 'admin_users'
  filter :admin_priority, as: :select, label: 'Admina prioritāte', collection: -> {Task::PRIORITY.each {|k,v| [k,v] }}, if: proc {can? :manage, AdminUser}
  filter :user_priority, as: :select, label: 'Darbinieka prioritāte', collection: -> {Task::PRIORITY.each {|k,v| [k,v] }}

  form do |f|
    f.panel 'Pamatinformācija' do 
      f.inputs do
        f.input :admin_user_id, as: :hidden
        f.input :creator_id, as: :hidden
        f.input :state, as: :hidden 
        f.input :company_id, as: :hidden
        f.input :name, label: 'Temats'
        f.input :category, label: 'Kategorija', include_blank: false
        f.input :description, label: 'Aprkasts'
        if can? :manage, AdminUser
          f.input :company_id, as: :select, collection: Company.all.map{|u| ["#{u.name}", u.id]},
            label: 'Uzņēmums' if ActiveRecord::Base.connection.table_exists? 'companies'
          f.input :user_priority, as: :select, collection: Task::PRIORITY,
            include_blank: false, label: 'Darbinieka prioritāte'
          f.input :admin_priority, as: :select, collection: Task::PRIORITY,
            include_blank: false, label: 'Admina prioritāte'
          f.input :employee_deadline, as: :date_time_picker, datepicker_options: {lang: 'lv'}, label: 'Darbinieka termiņš', class: 'date_time_picker datetime_field', allow_blank: false
          f.input :admin_deadline, as: :date_time_picker, label: 'Admina termiņš', class: 'date_time_picker datetime_field'
          f.input :responsible_id, :as => :select, :collection => 
            AdminUser.admins, label: 'Atbildīgais administrators'
        else
          f.input :user_priority, as: :select, collection: Task::PRIORITY,
            include_blank: false, label: 'Prioritāte'
          f.input :employee_deadline, as: :date_time_picker, datepicker_options: {min_date: '0', min_time: '0', lang: 'lv'}, label: 'Izpildes termiņš'
        end
      end
    end

    f.panel 'Attēlu pielikums' do
      f.has_many :task_images, heading: false do |i|
        # i.input :name, label:''
        i.input :image, :as => :file, label: 'Fails'
        i.input :description, as: :string, label: 'Aprkasts'
      end
    end
    f.actions do
      f.action(:submit) + f.cancel_link(request.referer)
    end
  end

  index title: proc{'Pieteikumu saraksts'} do 
    column 'Temats', sortable: :name do |t| link_to t.name, admin_task_path(t) end
    # column 'Aprkasts', :description do |t| truncate(t.description, length: 30) end
    column 'Kategorija', sortable: :category_id do |t| Category.find(t.category_id).name end
    # column 'Atbildīgais lietotājs' do |t| AdminUser.find(t.responsible_id).full_name rescue "Nav noteikts" end
    column 'Izveidotājs', sortable: :creator_id do |t| AdminUser.find(t.creator_id).full_name end
    if can? :manage, AdminUser
      column 'Atbildīgais lietotājs', :responsible_id do |t| 
        best_in_place t, :responsible_id, :as => :select, url: [:admin, t], :collection => AdminUser.admins.map{|u| [u.id, u.full_name]} rescue '-'
      end
      column 'Uzņēmums' do |t| Company.find(t.company_id).name rescue "-" end 
      column 'Admina prioritāte', :admin_priority do |t|
        best_in_place t, :admin_priority , as: :select, url: [:admin, t], collection: Task::PRIORITY.keys,
        value: Task::PRIORITY.key(t.admin_priority), class: "best_in_place"
      end
      column 'Darbinieka prioritāte', :user_priority do |t| 
        best_in_place t, :user_priority , as: :select, url: [:admin, t], collection: Task::PRIORITY.keys,
        value: Task::PRIORITY.key(t.user_priority), class: "best_in_place"
      end
      column 'Stavoklis' do |t|
        best_in_place t, :state , as: :select, url: [:admin, t], collection: Task::STATUS.keys,
        value: Task::STATUS.key(t.state), class: "state_button best_in_place #{Task::STATUS.key(t.state)}"
      end
    else
      column 'Prioritāte', :user_priority do |t| span class: "state_button #{Task::PRIORITY.key(t.user_priority).gsub(' ','_' )}" do Task::PRIORITY.key(t.user_priority) end end
      column 'Stavoklis', :state do |t| span class: "state_button #{Task::STATUS.key(t.state)}" do Task::STATUS.key(t.state) end end
    end
    actions do |t|
      if t.closed_by_employee || t.closed_by_admin
        link_to 'Atsaukt atcelšanu', close_admin_task_path(t)
      else
        link_to 'Atcelt pieteikumu', close_admin_task_path(t)
      end
    end
  end


  show do
    columns do
      column do
        panel 'Pieteikuma informācija' do
          attributes_table_for task do
            row 'Uzņēmums', :company_id do |t| t.company.name rescue '-' end
            row 'Temats', :name do |t| t.name end
            row 'Kategorija' do |t| Category.find(t.category_id).name end
            row 'Atbildīgais lietotājs' do |t| AdminUser.find(t.responsible_id).full_name rescue "-" end
            row 'Izveidotājs' do |t| AdminUser.find(t.creator_id).full_name end
    
            if can? :manage, AdminUser
              row 'Darbinieka termiņš', :employee_deadline do |t| t.employee_deadline.strftime('%d.%m.%Y %H:%M') rescue "-" end
              row 'Admina termiņš', :admin_deadline do |t| t.admin_deadline.strftime('%d.%m.%Y %H:%M') rescue "-" end 
              row 'Admina prioritāte', :admin_priority do |t| Task::PRIORITY.key(t.admin_priority) end
              row 'Darbinieka prioritāte', :user_priority do |t| Task::PRIORITY.key(t.user_priority) end
              row 'Stavoklis', :state do |t|
                best_in_place t, :state , as: :select, url: [:admin, t], collection: Task::STATUS.keys,
                value: Task::STATUS.key(t.state), class: "state_button best_in_place #{Task::STATUS.key(t.state)}"
              end
              row 'Patērētais laiks(h)' do |t| 
                best_in_place t.task_logs.last.nil? ? tl = t.task_logs.create!() : tl = t.task_logs.last, :time,
                  as: :input, url: [:admin,t,tl], class: "best_in_place", place_holder: "------" end
              # column '' do |t| link_to 'Pārskatīt pierakstītos laikus', admin_task_task_logs_path(t) end    
            else
              row 'Termiņš' do |t| t.employee_deadline.strftime('%d.%m.%Y %H:%M') end
              row 'Prioritāte', :user_priority do |t| Task::PRIORITY.key(t.user_priority) end
              row 'Stavoklis' do |t| Task::STATUS.key(t.state) end
            end
            row 'Atcelt' do |t| 
              if t.closed_by_employee || t.closed_by_admin
                link_to 'Atsaukt atcelšanu', close_admin_task_path(t)
              else
                link_to 'Atcelt pieteikumu', close_admin_task_path(t)
              end
            end
          end
        end
      end

      column span: 3 do
        panel 'Aprkasts' do
          div class: 'text_display' do 
            simple_format task.description
          end
        end
      end
    end

    panel 'Pieteikuma attēli' do
      table_for task.task_images do
        column 'Attēls' do |attachment| link_to (image_tag attachment.image.url(:thumb)), attachment.image.url, target: '_blank' end
        column 'Piebilde', :description
        column 'Izveidots', :created_at
        column '' do |attachment| link_to 'Noņemt pielikumu', admin_task_task_image_path(task, attachment),
          data: {:confirm => 'Esat pārliecināts?'}, :method => :delete end
      end
      li link_to 'Pievienot attēlu', edit_admin_task_path(task)
    end
    if can? :manage,  AdminUser
      panel 'Nosūtītie ziņojumi' do
        table_for task.task_emails do
          column 'Temats' do |m| link_to m.title, admin_task_task_email_path(task_id: params[:id], id: m.id) end 
          column 'Sūtītājs' do |m| AdminUser.find(m.sender_id).email end
          column 'Nosūtīts' do |m| I18n.l(m.created_at) end
        end
      end
    end
    active_admin_comments
  end

end
