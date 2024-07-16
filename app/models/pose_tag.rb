class PoseTag < ApplicationRecord
  belongs_to :pose
  belongs_to :tag

  validates :post_id, uniqueness: { scope: :tag_id }
end
