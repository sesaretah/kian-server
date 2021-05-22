class AddModuleToCourseSco < ActiveRecord::Migration[5.2]
  def change
    add_column :course_scos, :module, :string
  end
end
