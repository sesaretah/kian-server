class CreateBbMeetings < ActiveRecord::Migration[5.2]
  def change
    create_table :bb_meetings do |t|
      t.string :record_id
      t.integer :course_id
      t.integer :duration
      t.integer :number_of_participants
      t.datetime :start_time

      t.timestamps
    end
    add_index :bb_meetings, :record_id
    add_index :bb_meetings, :course_id
  end
end
