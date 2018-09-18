class Like < ApplicationRecord
  belongs_to :user
  belongs_to :tweet, counter_cache: :number_of_likes

  validates :user, :tweet, presence: true
  validates :user, uniqueness: { scope: :tweet,
    message: "User can't like the same tweet more than once" }
  validates_with UserShouldExistValidator
  validates_with TweetValidator
end
