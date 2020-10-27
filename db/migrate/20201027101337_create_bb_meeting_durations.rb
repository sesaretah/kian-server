class CreateBbMeetingDurations < ActiveRecord::Migration[5.2]
  def change
    create_table :bb_meeting_durations do |t|
      t.integer :course_id
      t.integer :duration

      t.timestamps
    end
    add_index :bb_meeting_durations, :course_id
  end
end
