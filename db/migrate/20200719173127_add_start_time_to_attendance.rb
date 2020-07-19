class AddStartTimeToAttendance < ActiveRecord::Migration[5.2]
  def change
    add_column :attendances, :start_time, :datetime
  end
end
