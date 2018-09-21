class TweetShouldntSelfMentionValidator < ActiveModel::Validator
  def validate record
    if (Tweet.exists? record.tweet_id) && (record.user_id == Tweet.find(record.tweet_id).user_id)
      record.errors.add :tweet, 'shouldn`t self mention the user'
    end
  end
end