class AddUtidToProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :utid, :string
    add_index :profiles, :utid
  end
end
