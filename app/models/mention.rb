class Mention < ApplicationRecord
  belongs_to :user
  belongs_to :tweet

  validates :user, uniqueness: { scope: :tweet,
    message: 'No more than one mention is necessary when the same user is mentioned multiple times in same tweet' }
  validates :user, presence: true
  validates :tweet, presence: true
  validates_with UserShouldExistValidator
  validates_with TweetValidator
end
