class TweetSelfMentionValidator < ActiveModel::Validator
  def validate(record)
    if record.user_id == Tweet.find(record.tweet_id).user_id
      record.errors.add(:mention, " Tweet shouldn't self mention the user")
    end
  end
end