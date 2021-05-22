class AddCourseIdToAttendance < ActiveRecord::Migration[5.2]
  def change
    add_column :attendances, :course_id, :integer
  end
end
