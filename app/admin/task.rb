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

  permit_params :name, :description, :deadline, :category_id, :creator_id, :responsible_id,
  task_images_attributes: [:name, :description, :image_file_name, :_destroy]

  before_build do |record|
    record.creator_id = current_admin_user.id
  end

  controller do
    #load_and_authorize_resource

    def new
      @task = Task.new
      @task.task_images.build
    end
  end

  form do |f|
    f.inputs 'Pamatinformācija' do
      f.input :name, label: 'Temats'
      f.input :category, label: 'Kategorija'
      f.input :description, label: 'Aprkasts'
      f.input :deadline, label: 'Aptuvenais izpildes termiņš'
      f.input :responsible_id, :as => :select, :collection => AdminUser.all.map{|u| ["#{u.last_name}, #{u.first_name}", u.id]}, label: 'Atbildīgais administrators'
    end

    f.inputs :name => 'Attēlu pielikums', :for => :task_image do |t|
      # t.input :name, label:''
      t.input :image, :as => :file, label: 'Fails'
      t.input :description, label: 'Aprkasts'
    end
    f.actions
  end

  index do 
    column 'Issue topic', :name
    column :description
    column 'Category' do |t| Category.find(t.category_id).name end
    column 'Responsible user', :responsible_id
    column 'Images'
    column 'State'
    actions
  end

end
