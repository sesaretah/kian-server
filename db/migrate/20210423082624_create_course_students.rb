class CreateCourseStudents < ActiveRecord::Migration[5.2]
  def change
    create_table :course_students do |t|
      t.integer :course_id
      t.string :fullname
      t.integer :user_id

      t.timestamps
    end
  end
end
