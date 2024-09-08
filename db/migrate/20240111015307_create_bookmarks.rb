# frozen_string_literal: true

class CreateBookmarks < ActiveRecord::Migration[7.1]
  def change
    create_table :bookmarks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :pose, null: false, foreign_key: true

      t.timestamps
    end
    add_index :bookmarks, %i[user_id pose_id], unique: true
  end
end
