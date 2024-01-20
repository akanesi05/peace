class Pose < ApplicationRecord
  belongs_to :user
  has_many :bookmarks, dependent: :destroy
  mount_uploader :image, ImageUploader

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "image", "name", "updated_at", "user_id"]
  end
end
