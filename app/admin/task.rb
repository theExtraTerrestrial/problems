ActiveAdmin.register Task do
  ActiveAdmin.register TaskImage do
    belongs_to :task

    controller do
      def destroy
        @task_image = TaskImage.find(params[:id])
        @task = @task_image.task
        @task_image.destroy
        flash[:success] = 'Pielikums veiksmīgi dzēsts'
        redirect_to admin_task_path(@task)
      end

      def cancel
        raise params.inspect
      end
    end
  end
  
  menu label: 'Pieteikumi'

  permit_params :name, :description, :admin_deadline, :employee_deadline, :state,
    :category_id, :creator_id, :responsible_id, :admin_priority, :user_priority,
    task_images_attributes: [:id, :name, :description, :image, :_destroy],
    task_logs_attributes: [:id, :time, :description, :task_id, :_destroy]

  before_build do |record|
    record.creator_id = current_admin_user.id
    record.state = 1
  end

  member_action :close, method: :put do
    if record.closed_by_admin || record.closed_by_employee
      if can? :manage, AdminUser
        resource.update_attribute('closed_by_admin', true)
        resource.update_attribute('state', 3)
      else
        resource.update_attribute('closed_by_employee', true)
        resource.update_attribute('state', 3)
      end
      redirect_to admin_tasks_path, notice: "Pieteikums ir atcelts"
    else
      if can? :manage, AdminUser
        resource.update_attribute('closed_by_admin', false)
        resource.update_attribute('state', 1)
      else
        resource.update_attribute('closed_by_employee', false)
        resource.update_attribute('state', 1)
      end
      redirect_to admin_tasks_path, notice: "Pieteikuma atcelšana ir atsaukta"
    end
  end

  form do |f|
    f.panel 'Pamatinformācija' do 
      f.inputs do
        f.input :name, label: 'Temats'
        f.input :category, label: 'Kategorija', include_blank: false
        f.input :description, label: 'Aprkasts'
        if can? :manage, AdminUser
          f.input :user_priority, as: :select, collection: Task::PRIORITY,
            include_blank: false, label: 'Darbinieka prioritāte'
          f.input :admin_priority, as: :select, collection: Task::PRIORITY,
            include_blank: false, label: 'Admina prioritāte'
          f.input :employee_deadline, as: :date_time_picker, label: 'Darbinieka izpildes termiņš', class: 'date_time_picker'
          f.input :admin_deadline, as: :date_time_picker, label: 'Admina izpildes termiņš', class: 'date_time_picker'
          f.input :responsible_id, :as => :select, :collection => 
            AdminUser.admins, label: 'Atbildīgais administrators'
          # f.fields_for :task_log do |log|
          #   log.inputs do
          #     log.input :time, label: 'Nostrādātais laiks(h)'
          #     log.input :description, label: 'Piebilde'
          #   end
          # end
        else
          f.input :user_priority, as: :select, collection: Task::PRIORITY,
            include_blank: false, label: 'Prioritāte'
          f.input :employee_deadline, as: :date_time_picker, label: 'Izpildes termiņš'
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
    f.actions
  end

  index do 
    selectable_column
    column 'Temats', :name
    column 'Aprkasts', :description
    column 'Kategorija' do |t| Category.find(t.category_id).name end
    column 'Atbildīgais lietotājs' do |t| AdminUser.find(t.responsible_id).full_name rescue "-" end
    column 'Izveidotājs' do |t| AdminUser.find(t.creator_id).full_name end
    if can? :manage, AdminUser 
      column 'Admina prioritāte', :admin_priority do |t| Task::PRIORITY.key(t.admin_priority) end
      column 'Darbinieka prioritāte', :user_priority do |t| Task::PRIORITY.key(t.user_priority) end
      column 'Stavoklis' do |t|
        best_in_place t, :state , as: :select, url: [:admin, t], collection: Task::STATUS.keys,
        value: Task::STATUS.key(t.state), class: "state_button best_in_place #{Task::STATUS.key(t.state)}"
      end
    else
      column 'Prioritāte', :user_priority do |t| Task::PRIORITY.key(t.user_priority) end
      column 'Stavoklis' do |t| Task::STATUS.key(t.state) end
    end
    actions
  end


  show do
    panel 'Pieteikuma informācija' do
      table_for task do
        column 'Temats', :name
        column 'Aprkasts', :description
        column 'Kategorija' do |t| Category.find(t.category_id).name end
        column 'Atbildīgais lietotājs' do |t| AdminUser.find(t.responsible_id).full_name rescue "-" end
        column 'Izveidotājs' do |t| AdminUser.find(t.creator_id).full_name end
        if can? :manage, AdminUser
          column 'Darbinieka noteiktais termiņš' do |t| t.employee_deadline end
          column 'Admina termiņš' do |t| t.admin_deadline end 
          column 'Admina prioritāte', :admin_priority do |t| Task::PRIORITY.key(t.admin_priority) end
          column 'Darbinieka prioritāte', :user_priority do |t| Task::PRIORITY.key(t.user_priority) end
          column 'Stavoklis' do |t|
            best_in_place t, :state , as: :select, url: [:admin, t], collection: Task::STATUS.keys,
            value: Task::STATUS.key(t.state), class: "state_button best_in_place #{Task::STATUS.key(t.state)}"
          end
          column '' do |t| 
            if t.closed_by_employee || t.closed_by_admin
              link_to 'Atsaukt atcelšanu', {controller: 'tasks', action: 'close', method: :put}
            else
              link_to 'Atcelt pieteikumu', {controller: 'tasks', action: 'close', method: :put}
            end
          end
        else
          column 'Termiņš' do |t| t.employee_deadline end
          column 'Prioritāte', :user_priority do |t| Task::PRIORITY.key(t.user_priority) end
          column 'Stavoklis' do |t| Task::STATUS.key(t.state) end
          column '' do |t| 
            if t.closed_by_employee || t.closed_by_admin
              link_to 'Atsaukt atcelšanu', {controller: 'task', action: 'close', method: :put}
            else
              link_to 'Atcelt pieteikumu', {controller: 'task', action: 'close', method: :put}
            end
          end
        end
      end
    end

    panel 'Pieteikuma attēli' do
        table_for task.task_images do
          column 'Piebilde', :description
          column 'Attēls' do |attachment| image_tag attachment.image.url(:thumb).html_safe end
          column 'Izveidots', :created_at
          column '' do |attachment| link_to 'Noņemt pielikumu', admin_task_task_image_path(task, attachment),
            data: {:confirm => 'Esat pārliecināts?'}, :method => :delete end
        end
    end

    panel 'Patērētais laiks' do
      table_for task.task_logs do
        column 'Laiks', :time
        column 'Piebilde', :description
        column '' do |t| link_to '' end
      end
    end
    active_admin_comments
  end

  # sidebar "Details", only: :show do
  #   attributes_table_for task do
  #     row :name
  #     row :creator_id
  #     row :employee_deadline
  #     row :employee_priority
  #     row('State') { |b| Task::STATUS.key(b.state) }
  #   end
  # end

end
