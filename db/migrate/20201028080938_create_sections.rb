class CreateSections < ActiveRecord::Migration[5.2]
  def change
    create_table :sections do |t|
      t.string :title
      t.integer :mid

      t.timestamps
    end
    add_index :sections, :mid
  end
end
