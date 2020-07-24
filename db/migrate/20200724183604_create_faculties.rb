class CreateFaculties < ActiveRecord::Migration[5.2]
  def change
    create_table :faculties do |t|
      t.integer :serial
      t.string :fullname

      t.timestamps
    end
    add_index :faculties, :serial
  end
end
