class AddAssetIdToAttendances < ActiveRecord::Migration[5.2]
  def change
    add_column :attendances, :asset_id, :integer
  end
end
