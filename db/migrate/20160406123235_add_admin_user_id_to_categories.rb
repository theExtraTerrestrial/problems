class AddAdminUserIdToCategories < ActiveRecord::Migration
  def up
    add_column :categories, :admin_user_id, :integer
  end

  def down
    remove_column :categories, :admin_user_id, :integer
  end
end
