# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 20_240_716_123_030) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'bookmarks', force: :cascade do |t|
    t.bigint 'user_id', null: false
    t.bigint 'pose_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['pose_id'], name: 'index_bookmarks_on_pose_id'
    t.index %w[user_id pose_id], name: 'index_bookmarks_on_user_id_and_pose_id', unique: true
    t.index ['user_id'], name: 'index_bookmarks_on_user_id'
  end

  create_table 'pose_tags', force: :cascade do |t|
    t.bigint 'pose_id', null: false
    t.bigint 'tag_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[pose_id tag_id], name: 'index_pose_tags_on_pose_id_and_tag_id', unique: true
    t.index ['pose_id'], name: 'index_pose_tags_on_pose_id'
    t.index ['tag_id'], name: 'index_pose_tags_on_tag_id'
  end

  create_table 'poses', force: :cascade do |t|
    t.string 'name'
    t.string 'image'
    t.bigint 'user_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['user_id'], name: 'index_poses_on_user_id'
  end

  create_table 'tags', force: :cascade do |t|
    t.string 'name', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['name'], name: 'index_tags_on_name', unique: true
  end

  create_table 'users', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'email', null: false
    t.string 'crypted_password'
    t.string 'salt'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_token_expires_at'
    t.datetime 'reset_password_email_sent_at'
    t.integer 'access_count_to_reset_password_page', default: 0
    t.string 'avatar'
    t.string 'favorite_genre'
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token'
  end

  add_foreign_key 'bookmarks', 'poses'
  add_foreign_key 'bookmarks', 'users'
  add_foreign_key 'pose_tags', 'poses'
  add_foreign_key 'pose_tags', 'tags'
  add_foreign_key 'poses', 'users'
end
