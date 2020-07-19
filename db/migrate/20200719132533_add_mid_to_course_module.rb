class AddMidToCourseModule < ActiveRecord::Migration[5.2]
  def change
    add_index :course_modules, :mid
  end
end
