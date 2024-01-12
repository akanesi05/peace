class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :pose

  validates :user_id, uniqueness: { scope: :pose_id }
end
