class AddObjectChangesToVersions < ActiveRecord::Migration
  def up
    add_column :versions, :object_changes, :text
  end

  def down
    remove_column :versions, :object_changes, :text
  end
end
