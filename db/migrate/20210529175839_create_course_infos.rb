class CreateCourseInfos < ActiveRecord::Migration[5.2]
  def change
    create_table :course_infos do |t|
      t.integer :course_id
      t.integer :resources
      t.integer :exams
      t.integer :exercises
      t.integer :number_of_sessions
      t.integer :session_durations
      t.float :teacher_view_mean
      t.float :student_view_mean

      t.timestamps
    end
    add_index :course_infos, :course_id
  end
end
