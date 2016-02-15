class AddImageToImageTasks < ActiveRecord::Migration
  def up
    add_attachment :task_images, :image
  end

  def down
    remove_attachment :task_images, :image
  end
end
