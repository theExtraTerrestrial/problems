class CreateTaskImages < ActiveRecord::Migration
  def change
    create_table :task_images do |t|
      t.integer :task_id
      t.text :description
      t.string :name
      t.timestamps null: false
    end
  end
end
