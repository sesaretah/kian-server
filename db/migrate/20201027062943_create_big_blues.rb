class CreateBigBlues < ActiveRecord::Migration[5.2]
  def change
    create_table :big_blues do |t|
      t.integer :mid
      t.integer :module_id
      t.integer :course_id
      t.integer :user_id
      t.string :meeting_id

      t.timestamps
    end
    add_index :big_blues, :mid
  end
end
