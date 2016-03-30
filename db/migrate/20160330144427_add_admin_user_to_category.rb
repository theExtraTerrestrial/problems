class AddAdminUserToCategory < ActiveRecord::Migration
  def up
    add_column :categories, :responsible_id, :integer
  end

  def down
    remove_column :categories, :responsible_id, :integer
  end
end
