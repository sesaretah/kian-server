class AddSectionsToSkope < ActiveRecord::Migration[5.2]
  def change
    add_column :skopes, :sections, :json
  end
end
