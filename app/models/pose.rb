class Pose < ApplicationRecord
  belongs_to :user
  has_many :bookmarks, dependent: :destroy
  mount_uploader :image, ImageUploader
  validates :name, presence: true
  validate :image_presence

  def image_presence
  errors.add(:image, "をアップロードしてください") unless image.present?
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "image", "name", "updated_at", "user_id"]
  end
end
