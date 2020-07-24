class CreateMeetingDurations < ActiveRecord::Migration[5.2]
  def change
    create_table :meeting_durations do |t|
      t.integer :course_id
      t.integer :duration

      t.timestamps
    end
    add_index :meeting_durations, :course_id
  end
end
