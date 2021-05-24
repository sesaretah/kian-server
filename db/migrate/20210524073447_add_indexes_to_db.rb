class AddIndexesToDb < ActiveRecord::Migration[5.2]
  def change
    add_index :attendances, :asset_id
    add_index :attendances, :duration
    add_index :attendances, :module
    add_index :attendances, :course_id
    add_index :course_scos, :module
    add_index :course_teachers, :user_id

    add_index :big_blues, :module_id
    add_index :big_blues, :course_id
    add_index :big_blues, :user_id
    add_index :big_blues, :meeting_id
    add_index :bb_meetings, :start_time

    add_index :course_modules, :semster
    add_index :course_meetings, :start_time
    add_index :courses, :group_id
    add_index :courses, :faculty_id

    add_index :meetings, :start_time
  end
end
