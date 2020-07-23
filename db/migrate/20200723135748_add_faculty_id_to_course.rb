class AddFacultyIdToCourse < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :faculty_id, :integer
  end
end
