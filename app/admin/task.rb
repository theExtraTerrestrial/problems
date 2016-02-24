ActiveAdmin.register Task do
  ActiveAdmin.register TaskImage do
    belongs_to :task
  end
  
  menu label: 'Pieteikumi'

  permit_params :name, :description, :deadline, :category_id, :creator_id, :responsible_id,
  task_images_attributes: [:id, :name, :description, :image, :_destroy]

  before_build do |record|
    record.creator_id = current_admin_user.id
  end

  controller do
  # load_and_authorize_resource
    def new
      @task = Task.new
      # @task.task_images.build
    end
  end

  form do |f|
    f.panel 'Pamatinformācija' do 
      f.inputs do
        f.input :name, label: 'Temats'
        f.input :category, label: 'Kategorija'
        f.input :description, label: 'Aprkasts'
        f.input :deadline, as: :date_time_picker, label: 'Izpildes termiņš'
        if can? :manage, AdminUser
          f.input :responsible_id, :as => :select, :collection =>
            AdminUser.all.map{|u| ["#{u.last_name}, #{u.first_name}", u.id]},
            label: 'Atbildīgais administrators'
          f.input :admin_priority, as: :select, collection: Task::PRIORITY, include_blank: false
        end

      end
    end

    f.panel 'Attēlu pielikums' do
      f.has_many :task_images, heading: false do |i|
        # i.input :name, label:''
        i.input :image, :as => :file, label: 'Fails'
        i.input :description, label: 'Aprkasts'
      end
    end
    f.actions
  end

  index do 
    column 'Temats', :name
    column 'Aprkasts', :description
    column :admin_priority do |t| Task::PRIORITY.key(t.admin_priority) end
    column :user_priority do |t| Task::PRIORITY.key(t.user_priority) end
    column 'Kategorija' do |t| Category.find(t.category_id).name end
    column 'Atbildīgais lietotājs' do |t| AdminUser.find(t.responsible_id).full_name rescue "-" end
    column 'Izveidotājs' do |t| AdminUser.find(t.creator_id).full_name end
    column 'Stavoklis'
    actions
  end

  show do
    attributes_table do
      row 'Temats', :name
      row 'Aprkasts', :description
      row 'Kategorija' do |t| Category.find(t.category_id).name end
      row 'Atbildīgais lietotājs' do |t| AdminUser.find(t.responsible_id).full_name rescue "-" end
      row 'Izveidotājs' do |t| AdminUser.find(t.creator_id).full_name end
      # row 'Attēli' do |t| 
      #     # image_tag image.url(:thumb).html_safe
          
          
      #   # end
      #   arr = ""
      #   t.task_images.each do |a|
      #     arr += "<img src='#{a.image.url}' /> "
      #   end  
      #   arr.html_safe

      # end
      row 'Stavoklis' do |s| Task::STATUS.key(t.category_id) end
    end

    panel(I18n.t("documents.incoming.attachments.title"), :class => "new_event_panel seventy_percnt_panel panel") do
        table_for(task.task_images) do
          column I18n.t("documents.incoming.attachments.name"), :name
          column I18n.t("documents.incoming.attachments.file") do |attachment| image_tag attachment.image.url(:thumb).html_safe end
          column I18n.t("documents.incoming.attachments.created_at"), :created_at
        end
      end

    active_admin_comments
  end

end
