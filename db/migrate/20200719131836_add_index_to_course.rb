class AddIndexToCourse < ActiveRecord::Migration[5.2]
  def change
    add_index :courses, :mid
    add_index :course_modules, :course_id
    add_index :course_modules, :module_id
    add_index :meetings, :course_module_id
    add_index :meetings, :sco_id
  end
end
