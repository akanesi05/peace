class Tag < ApplicationRecord
    has_many :pose_tags, dependent: :destroy
    has_many :pose, through: :pose_tags
    validates :name, length: { in: 1..10 }, uniqueness: true
end
