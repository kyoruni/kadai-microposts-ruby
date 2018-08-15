class Micropost < ApplicationRecord
  belongs_to :user

  has_many :likes
  has_many :liked_user, through: :likes, source: :micropost

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 255 }
end
