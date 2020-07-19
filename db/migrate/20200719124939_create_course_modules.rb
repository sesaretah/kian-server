class CreateCourseModules < ActiveRecord::Migration[5.2]
  def change
    create_table :course_modules do |t|
      t.integer :module_id
      t.integer :course_id
      t.integer :mid

      t.timestamps
    end
  end
end
