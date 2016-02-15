ActiveAdmin.register Task do
  ActiveAdmin.register TaskImage do
    belongs_to :task
    form do |f|
      f.inputs 'Image information' do |i|
        i.input :name
        i.input :image, :as => :file
        i.input :description
      end
      f.submit
    end
  end

  permit_params :name, :description, :deadline, :category_id, :user_id, :creator_id, :responsible_id,
  task_images_attributes: [:name, :description, :image_file_name, :_destroy]


  controller do
    def new
      @task = Task.new
      @task.task_images.build
      @task.creator_id = current_user
    end
  end
  form do |f|
    f.inputs 'Basic Details' do
      f.input :name
      f.input :description
      f.input :deadline
      f.input :category
    end

    f.inputs :name => 'Image information', :for => :task_image do |t|
      t.input :name
      t.input :image, :as => :file
      t.input :description
    end
    f.actions
  end
end
