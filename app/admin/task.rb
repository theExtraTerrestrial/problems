ActiveAdmin.register Task do
  ActiveAdmin.register TaskImage do
    belongs_to :task
    form do |f|
      f.inputs 'Attēlu pielikums' do |i|
        # i.input :name, label:''
        i.input :image, :as => :file
        i.input 'Aprkasts', :description
      end
      f.actions
    end
  end
  
  menu label: 'Pieteikumi'

  permit_params :name, :description, :deadline, :category_id, :creator_id, :responsible_id,
  task_images_attributes: [:name, :description, :image_file_name, :_destroy]

  before_build do |record|
    record.creator_id = current_admin_user.id
  end

  controller do
  # load_and_authorize_resource
    def new
      @task = Task.new
      @task.task_images.build
    end
  end

  form do |f|
    f.inputs 'Pamatinformācija' do
      f.input :name, label: 'Temats'
      f.input :category, label: 'Kategorija'
      # f.input :admin_priority, as: :select, collection: Task::PRIORITY, include_blank: false
      f.input :description, label: 'Aprkasts'
      f.input :deadline, label: 'Aptuvenais izpildes termiņš'
      if can? :create, AdminUser
        f.input :responsible_id, :as => :select, :collection => AdminUser.all.map{|u| ["#{u.last_name}, #{u.first_name}", u.id]}, label: 'Atbildīgais administrators'
      end
    end

    f.inputs :name => 'Attēlu pielikums', :for => :task_image do |t|
      # t.input :name, label:''
      t.input :image, :as => :file, label: 'Fails'
      t.input :description, label: 'Aprkasts'
    end
    f.actions
  end

  index do 
    column 'Temats', :name
    column 'Aprkasts', :description
    # column 'Admin prioritāte' do |t| Task::PRIORITY.key(t.category_id).name end
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
