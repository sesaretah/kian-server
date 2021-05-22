class AddModuleToAttendance < ActiveRecord::Migration[5.2]
  def change
    add_column :attendances, :module, :string
  end
end
