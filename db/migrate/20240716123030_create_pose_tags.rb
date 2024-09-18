class CreatePoseTags < ActiveRecord::Migration[7.1]
  def change
    create_table :pose_tags do |t|
      t.references :pose, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
    add_index :pose_tags, %i[pose_id tag_id], unique: true
  end
end
