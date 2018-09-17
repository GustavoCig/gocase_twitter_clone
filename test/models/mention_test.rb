require 'test_helper'

class MentionTest < ActiveSupport::TestCase
  test "mentioning somebody should generate a mention in the database" do
    user_1 = User.first
    user_2 = User.find(2)
    username_1 = "@" + user_1.username
    user_2.create_tweet("hey my friend," + username_1 + ", nice to meet you")
    mention_of_user_1 = Mention.find_by(user: user_1)
    assert mention_of_user_1.errors.empty?
    assert_equal mention_of_user_1.tweet_id, Tweet.find_by(user: user_2).id
  end

  test "incorrect syntax in a mention shouldn't generate a mention in the database" do
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

  test "user self mentioning shouldn't generate a mention" do
    user_1 = User.first
    username_1 = "@" + user_1.username
    self_tweet = user_1.create_tweet("I am self mentioning like a dumbass " + username_1)
    assert_nil Mention.find_by(tweet: self_tweet)
  end

  test "many equal mentions in a single tweet shouldn't generate more than one mention in the database" do
    user_1 = User.first
    user_2 = User.find(2)
    username_2 = "@" + user_2.username
    user_1.create_tweet("Hey " + username_2 + " " + username_2 + " " + username_2)
    assert_equal 1, Mention.where(user: user_2).count
  end
end
