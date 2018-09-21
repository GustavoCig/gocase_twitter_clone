class Mention < ApplicationRecord
  belongs_to :user
  belongs_to :tweet

  validates :user, uniqueness: { scope: :tweet,
              message: 'Only one mention is necessary when the same user is mentioned multiple times' }
  validates :user, :tweet, presence: true
  validates_with UserShouldExistValidator
  validates_with TweetShouldExistValidator
  validates_with TweetShouldntSelfMentionValidator
end
