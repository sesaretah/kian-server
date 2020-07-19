class AddMidToMeeting < ActiveRecord::Migration[5.2]
  def change
    add_column :meetings, :mid, :integer
    add_index :meetings, :mid
  end
end
