class AddUserIdToCourseTeacher < ActiveRecord::Migration[5.2]
  def change
    add_column :course_teachers, :user_id, :integer
  end
end
