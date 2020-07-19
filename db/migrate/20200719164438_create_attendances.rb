class CreateAttendances < ActiveRecord::Migration[5.2]
  def change
    create_table :attendances do |t|
      t.integer :principal_id
      t.integer :sco_id
      t.integer :transcript_id

      t.timestamps
    end
    add_index :attendances, :principal_id
    add_index :attendances, :sco_id
    add_index :attendances, :transcript_id
  end
end
