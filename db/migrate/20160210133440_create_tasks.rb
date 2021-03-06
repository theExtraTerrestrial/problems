class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.integer :creator_id
      t.datetime :admin_deadline
      t.datetime :employee_deadline
      t.integer :state
      t.integer :responsible_id
      t.integer :category_id
      t.integer :admin_user_id
      t.integer :user_priority
      t.integer :admin_priority
      t.boolean :closed_by_admin
      t.boolean :closed_by_employee
      t.integer :company_id

      t.timestamps null: false
    end
  end
end
