class Tag < ApplicationRecord
    has_many :pose_tags, dependent: :destroy
    has_many :poses, through: :pose_tags
    validates :name, length: { in: 1..10 }, uniqueness: true
    def self.ransackable_attributes(auth_object = nil)
        ["created_at", "id", "id_value", "name", "updated_at"]
    end
    
end
