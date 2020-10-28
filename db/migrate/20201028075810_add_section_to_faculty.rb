class AddSectionToFaculty < ActiveRecord::Migration[5.2]
  def change
    add_column :faculties, :section, :integer
    add_index :faculties, :section
  end
end
