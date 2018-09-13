class Tweet < ApplicationRecord
  belongs_to :user
  has_many_attached :media
  has_many :mentions
  
  validates :message, length: { in: 1..120 }
  validates :user, :message, presence: true

  after_save :filter_regex

  MENTIONS_REGEX = /[@][a-zA-Z0-9]+/

  private

  # TODO #1:
  # Find a better approach to removing the '@'
  #
  # TODO #2: 
  # See if there is an approach that doesn't involve a loop in test_regex()
  # or a better approach overall 

  def filter_regex()
    matches = message.scan(MENTIONS_REGEX).uniq
    
    matches.each do |user| 
      matched_user = User.find_by(username: user.reverse!.chop!.reverse!)
      create_mentions(matched_user.id)   
    end
  end

  def create_mentions(user_id)
    Mention.create(user_id: user_id, tweet_id: self.id)
  end

end
