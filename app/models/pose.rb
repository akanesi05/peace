class Pose < ApplicationRecord
  belongs_to :user
  has_many :bookmarks, dependent: :destroy
  mount_uploader :image, ImageUploader
end
