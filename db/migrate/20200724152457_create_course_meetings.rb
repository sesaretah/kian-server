class CreateCourseMeetings < ActiveRecord::Migration[5.2]
  def change
    create_table :course_meetings do |t|
      t.integer :course_id
      t.datetime :start_time
      t.datetime :end_time
      t.integer :duration

      t.timestamps
    end
    add_index :course_meetings, :course_id
  end
end
