class CreateCourseScos < ActiveRecord::Migration[5.2]
  def change
    create_table :course_scos do |t|
      t.integer :course_id
      t.integer :sco_id

      t.timestamps
    end
    add_index :course_scos, :course_id
  end
end
