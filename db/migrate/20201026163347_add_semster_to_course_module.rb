class AddSemsterToCourseModule < ActiveRecord::Migration[5.2]
  def change
    add_column :course_modules, :semster, :integer
  end
end
