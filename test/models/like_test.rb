require 'test_helper'

class LikeTest < ActiveSupport::TestCase
  test 'user shouldnt be able to like the same tweet more than once' do
    user_1 = User.first
    user_2 = User.second
    tweet_to_be_liked = Tweet.new user: user_1, message: 'baiting for likes'
    
    Like.create user: user_1, tweet: tweet_to_be_liked
    Like.create user: user_2, tweet: tweet_to_be_liked

    user_1_repeated_like = Like.new user: user_1, tweet: tweet_to_be_liked
    user_2_repeated_like = Like.new user: user_1, tweet: tweet_to_be_liked

    assert_not user_1_repeated_like.valid?
    assert_not user_2_repeated_like.valid?
  end

  test 'liking a tweet should generate a Like in the database and increment the value of number_of_likes in th respective tweet' do
    tweet_to_be_liked = Tweet.first
    user_liker = User.first

    created_like = Like.create user: user_liker, tweet: tweet_to_be_liked
    assert Like.exists? created_like.id
    assert_equal 1, tweet_to_be_liked.number_of_likes
  end

  test 'unliking a tweet should destroy the Like in the database and decrement number_of_likes' do
    tweet_to_be_liked_and_destroyed = Tweet.first
    liker = User.first
    created_like = Like.create user: liker, tweet: tweet_to_be_liked_and_destroyed

    assert_equal 1, tweet_to_be_liked_and_destroyed.number_of_likes
    assert Like.exists? created_like.id
    Like.destroy created_like.id
    assert_equal 0, Tweet.find(tweet_to_be_liked_and_destroyed.id).number_of_likes
    assert_not Like.exists? created_like.id
  end

  test 'invalid/null parameters shouldnt create a Like' do
    invalid_user = User.new
    invalid_user_id = User.last.id + 1
    invalid_tweet = Tweet.new
    invalid_tweet_id = Tweet.last.id + 1

    invalid_user_like = Like.new user: invalid_user, tweet: Tweet.first 
    invalid_user_id_like = Like.new user_id: invalid_user_id, tweet: Tweet.first
    invalid_tweet_like = Like.new user: User.first, tweet: invalid_tweet
    invalid_tweet_id_like = Like.new user: User.first, tweet_id: invalid_tweet_id

    assert_not invalid_user_like.valid?
    assert_not invalid_user_id_like.valid?
    assert_not invalid_tweet_like.valid?
    assert_not invalid_tweet_id_like.valid?
  end
end
