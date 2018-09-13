require 'test_helper'

class MentionTest < ActiveSupport::TestCase
  test "correct use of mention regex should generate a mention in the database" do
    user_1 = User.first
    user_2 = User.find(2)

    username_1 = "@" + user_1.username
    user_2.create_tweet("hey my friend, " + username_1 + " nice to met you")

    mention_of_user_1 = Mention.find_by(user: user_1)
    assert mention_of_user_1.errors.empty?

    assert_equal mention_of_user_1.tweet_id, Tweet.find_by(user: user_2).id
  end

  test "incorrect use of the regular expression shouldn't generate a mention in the database" do
    
  end

  test "user self mentioning shouldn't generate a mention" do

  end

  test "many equal mentions in a single tweet shouldn't generate more than one mention in the database" do

  end
end
