class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.integer :creator_id
      t.datetime :deadline
      t.integer :responsible_id
      t.integer :category_id

      t.timestamps null: false
    end
  end
end
