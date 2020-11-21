class CreateSkopes < ActiveRecord::Migration[5.2]
  def change
    create_table :skopes do |t|
      t.string :utid
      t.json :domain

      t.timestamps
    end
    add_index :skopes, :utid
  end
end
