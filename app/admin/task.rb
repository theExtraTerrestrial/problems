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
        f.inputs do
          # i.input :name, label:''
         f.input :image_file_name, :as => :file, label: 'Fails'
         f.input :description, label: 'Aprkasts'
        end
      end
    end
    f.actions
  end

  index do 
    column 'Temats', :name
    column 'Aprkasts', :description
    column 'Admin prioritāte' do |t| Task::PRIORITY.key(t.category_id) end
    column 'Kategorija' do |t| Category.find(t.category_id).name end
    column 'Atbildīgais lietotājs' do |t| AdminUser.find(t.responsible_id).full_name rescue "-" end
    column 'Izveidotājs' do |t| AdminUser.find(t.creator_id).full_name end
    column 'Attēli', :image_file_name do |t| t.task_images.map(&:image).each do |i|
        image_tag i.url(:thumb)
      end
    end
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
      row 'Attēli' do |t| t.task_images.map(&:image).each do |image|
          image_tag image.url(:thumb)
        end
      end
      row 'Stavoklis'
    end
    active_admin_comments
  end

end
