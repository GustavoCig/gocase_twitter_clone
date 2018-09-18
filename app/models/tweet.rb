class Tweet < ApplicationRecord
  belongs_to :user
  has_many_attached :media
  has_many :mentions, dependent: :destroy
  has_many :likes, dependent: :destroy
  
  validates :message, length: { in: 1..120 }
  validates :user, :message, presence: true
  validates_with UserShouldExistValidator

  after_save :filter_regex

  MENTIONS_REGEX = /(?<=\!|\?|\:|\;|\s|\.|\,|\-|\A)@[a-zA-Z0-9]+(?=\!|\?|\:|\;|\s|\.|\,|\-|\z)/
  USER_REGEX = /[a-zA-Z0-9]+/

  private

  def filter_regex()
    matches = message.scan(MENTIONS_REGEX).uniq
    matches.each do |user|
      user_clean = USER_REGEX.match(user)
      matched_user = User.find_by(username: user_clean.to_s)
      create_mention(matched_user)   
    end
  end

  def create_mention(user)
    Mention.create(user: user, tweet: self)
  end
end
