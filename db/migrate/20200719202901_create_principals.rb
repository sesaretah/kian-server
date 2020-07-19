class CreatePrincipals < ActiveRecord::Migration[5.2]
  def change
    create_table :principals do |t|
      t.string :name
      t.integer :principal_id
      t.string :uid

      t.timestamps
    end
    add_index :principals, :principal_id
  end
end
