class CreateTaskEmails < ActiveRecord::Migration
  def change
    create_table :task_emails do |t|
      t.string :title
      t.string :description
      t.integer :task_id
      t.integer :sender_id
      t.integer :reciever_id

      t.timestamps null: false
    end
  end
end
