class CreateCoursePercentiles < ActiveRecord::Migration[5.2]
  def change
    create_table :course_percentiles do |t|
      t.float :resources
      t.integer :course_id
      t.float :exams
      t.float :exercises
      t.float :session_durations
      t.float :teacher_view
      t.float :student_view
      t.float :number_of_sessions

      t.timestamps
    end
    add_index :course_percentiles, :course_id
  end
end
