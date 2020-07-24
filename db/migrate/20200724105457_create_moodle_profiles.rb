class CreateMoodleProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :moodle_profiles do |t|
      t.integer :mid
      t.string :fullname
      t.string :utid

      t.timestamps
    end
    add_index :moodle_profiles, :mid
    add_index :moodle_profiles, :utid
  end
end
