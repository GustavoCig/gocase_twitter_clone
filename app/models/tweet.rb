class Tweet < ApplicationRecord
  belongs_to :user
  has_many_attached :media
  
  validates :message, length: { in: 1..120 }
  validates :id, uniqueness: true
  validates :id, :user_id, :message, presence: true
end
