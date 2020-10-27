class AddScoIdToCourseMeeting < ActiveRecord::Migration[5.2]
  def change
    add_column :course_meetings, :sco_id, :integer
    add_index :course_meetings, :sco_id
  end
end
