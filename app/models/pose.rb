class Pose < ApplicationRecord
  belongs_to :user
  has_many :bookmarks, dependent: :destroy
  mount_uploader :image, ImageUploader
  validates :name, presence: true
  #validate :pose_is_exist
  private

  #def pose_is_exist
      # if ! pose.where(id: pose_id).all.present?
      #     errors.add(:pose_id, "は存在しません。")
      # end
  #end
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "image", "name", "updated_at", "user_id"]
  end
end
