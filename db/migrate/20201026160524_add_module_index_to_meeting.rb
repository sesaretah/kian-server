class AddModuleIndexToMeeting < ActiveRecord::Migration[5.2]
  def change
    add_column :meetings, :module_index, :integer
  end
end
