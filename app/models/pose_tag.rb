class PoseTag < ApplicationRecord
  belongs_to :pose
  belongs_to :tag

  validates :pose_id, uniqueness: { scope: :tag_id }
end
