class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :poses
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_poses, through: :bookmarks, source: :pose
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :name, presence: true, length: { minimum: 3 }
  validates :email, presence: true, uniqueness: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }

  def own?(object)
    id == object&.user_id
  end

  def bookmark(pose)
    bookmark_poses << pose
  end

  def unbookmark(pose)
    bookmark_poses.destroy(pose)
  end


  def bookmark?(pose)
    bookmark_poses.include?(pose)
  end
end
