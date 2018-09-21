class TweetShouldExistValidator < ActiveModel::Validator
  def validate record
    if !Tweet.exists? record.tweet_id 
      record.errors.add :tweet, 'is invalid or doesn`t exist'
    end
  end
end