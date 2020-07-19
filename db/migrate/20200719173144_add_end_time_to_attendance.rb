class AddEndTimeToAttendance < ActiveRecord::Migration[5.2]
  def change
    add_column :attendances, :end_time, :datetime
  end
end
