# frozen_string_literal: true

class CreatePoses < ActiveRecord::Migration[7.1]
  def change
    create_table :poses do |t|
      t.string :name
      t.string :image

      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
