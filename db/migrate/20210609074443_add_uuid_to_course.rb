class AddUuidToCourse < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :uuid, :string
    add_index :courses, :uuid
  end
end
