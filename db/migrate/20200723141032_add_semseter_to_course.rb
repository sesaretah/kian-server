class AddSemseterToCourse < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :semster, :integer
  end
end
