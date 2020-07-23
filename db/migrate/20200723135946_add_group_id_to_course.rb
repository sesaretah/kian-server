class AddGroupIdToCourse < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :group_id, :integer
  end
end
