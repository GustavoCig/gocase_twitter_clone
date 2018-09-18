require 'test_helper'

class TweetTest < ActiveSupport::TestCase
  test "empty message tweets shouldn't be allowed" do
    user_1 = User.first
    empty_message_tweet  = Tweet.new(user: user_1, message: "")
    assert_not empty_message_tweet.valid?
  end

  test "invalid or null user tweets shouldn't be allowed" do
    invalid_user = User.new()
    invalid_user_id = User.last.id + 1
    empty_user_message = Tweet.new(message: "teste")
    invalid_user_tweet = Tweet.new(user: invalid_user, message: "teste usuario invalido")
    invalid_user_id_tweet = Tweet.new(user_id: invalid_user_id, message: "teste id de usuario invalido")

    assert_not empty_user_message.valid?
    assert_not invalid_user_tweet.valid?
    assert_not invalid_user_id_tweet.valid?
  end

  test "tweet mentioning somebody should generate a mention in the database" do
    user_1 = User.first
    user_2 = User.find(2)
    username_1 = "@" + user_1.username

    user_2.create_tweet("hey my friend," + username_1 + ", nice to meet you")
    mention_of_user_1 = Mention.find_by(user: user_1)

    assert mention_of_user_1.errors.empty?
    assert_equal mention_of_user_1.tweet_id, Tweet.find_by(user: user_2).id
  end

  test "incorrect syntax in a tweet shouldn't generate a mention in the database" do
    user_1 = User.first
    user_2 = User.find(2)
    username_1_with_exclamation = "@!" + user_1.username
    username_1_with_comma = "@," + user_1.username
    username_1_with_period = "@." + user_1.username
    username_1_with_interrogation = "@?" + user_1.username
    username_1_with_colon = "@:" + user_1.username

    tweet_exclamation = user_2.create_tweet("hey my friend, " + username_1_with_exclamation + " nice to meet you")
    tweet_comma = user_2.create_tweet("hey my friend, " + username_1_with_comma + " nice to meet you")
    tweet_period = user_2.create_tweet("hey my friend, " + username_1_with_period + " nice to meet you")
    tweet_interrogation = user_2.create_tweet("hey my friend, " + username_1_with_interrogation + " nice to meet you")
    tweet_colon = user_2.create_tweet("hey my friend, " + username_1_with_colon + " nice to meet you")

    assert tweet_exclamation.mentions.empty?
    assert tweet_comma.mentions.empty?
    assert tweet_period.mentions.empty?
    assert tweet_interrogation.mentions.empty?
    assert tweet_colon.mentions.empty?
  end

end
