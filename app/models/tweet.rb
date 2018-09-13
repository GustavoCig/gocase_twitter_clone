class Tweet < ApplicationRecord
  belongs_to :user
  has_many_attached :media
  has_many :mentions, dependent: :destroy
  
  validates :message, length: { in: 1..120 }
  validates :user, :message, presence: true

  after_save :filter_regex

  MENTIONS_REGEX = /[@][a-zA-Z0-9]+/

  private

  # TODO:
  # Find a better approach to removing the '@'
  #
  # See if there is an approach that doesn't involve a loop in test_regex()
  # or a better approach overall
  # 
  # Deal with certain characters in the mention regex (ex: ',')

  def filter_regex()
    matches = message.scan(MENTIONS_REGEX).uniq
    
    matches.each do |user| 
      matched_user = User.find_by(username: user.reverse!.chop!.reverse!)
      create_mention(matched_user)   
    end
  end

  def create_mention(user)
    Mention.create(user: user, tweet: self)
  end

end
