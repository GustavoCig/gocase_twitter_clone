require 'test_helper'

class MentionTest < ActiveSupport::TestCase
  test "mention with invalid/null parameters shouldn't be stored in the database" do
    invalid_user_id = User.last.id + 1
    invalid_user = User.new()
    invalid_tweet_id = Tweet.last.id + 1
    invalid_tweet = Tweet.new()

    invalid_user_id_mention = Mention.new(user_id: invalid_user_id, tweet: Tweet.first)
    invalid_user_mention = Mention.new(user: invalid_user, tweet: Tweet.first)
    invalid_tweet_id_mention = Mention.new(user: User.first, tweet_id: invalid_tweet_id)
    invalid_tweet_mention = Mention.new(user: User.first, tweet: invalid_tweet)

    assert_not invalid_user_id_mention.valid?
    assert_not invalid_user_mention.valid?
    assert_not invalid_tweet_id_mention.valid?
    assert_not invalid_tweet_mention.valid?
  end

  test "user self mentioning shouldn't generate a mention" do
    user_1 = User.first
    tweet_1 = Tweet.create(user: user_1, message: "self mentioning tweet")
    self_mention = Mention.new(user: user_1, tweet: tweet_1)

    assert_not self_mention.valid?
  end

  test "there shouldn't be more than one unique pair of tweet and user in the database" do
    user_1 = User.first
    user_2 = User.find(2)
    tweet_to_be_repeated = Tweet.create(user: user_1, message: "initial pair of tweet/user")
    Mention.create(user: user_2, tweet: tweet_to_be_repeated)
    repeated_mention = Mention.new(user: user_2, tweet: tweet_to_be_repeated)

    assert_not repeated_mention.valid?
  end
end
