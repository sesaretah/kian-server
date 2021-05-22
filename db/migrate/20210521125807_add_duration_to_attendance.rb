class AddDurationToAttendance < ActiveRecord::Migration[5.2]
  def change
    add_column :attendances, :duration, :integer
  end
end
