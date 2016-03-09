class CreateTaskLogs < ActiveRecord::Migration
  def change
    create_table :task_logs do |t|
      t.decimal :time,  precision: 10, scale: 8
      t.text :description
      t.integer :task_id

      t.timestamps null: false
    end
  end
end
