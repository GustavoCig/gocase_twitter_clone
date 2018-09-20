class TweetValidator < ActiveModel::Validator
  def validate(record)
    if !Tweet.exists?(record.tweet_id) 
      record.errors.add(:user, ' Tweet is invalid or doesn`t exist')
    elsif record.user_id == Tweet.find(record.tweet_id).user_id
      record.errors.add(:mention, ' Tweet shouldn`t self mention the user')
    end
  end
end