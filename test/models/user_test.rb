require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "users with invalid key parameters shouldn't be allowed" do
    user_repeated_email = User.new( username: "totallyuniquename2", email: User.first.email,
      password: "123456", name: "joaolul" )
    user_repeated_username = User.new( username: User.first.username, email: "totally@unique.com", 
      password: "123456", name: "xd" )

    user_without_username = User.new( email: "we@thebest.music", password: "123456", name: "xd" )
    user_without_password = User.new( username: "totallyuniqnameagain", email: "ano@ther.one", name: "xd" )
    user_without_email = User.new( username: "webackagainwiththeuninames", password: "123456", name: "xd" )
    user_without_name = User.new( username: "theoriginalityisastounding", email: "usmart@uloyal.com" , password: "123456" )

    user_name_too_small = User.new( username: "t", email: "westayin@fresh.onthestreets",
        password: "123456", name: "j" )
    user_name_too_large = User.new(username: "thisoriginalityisamazing", email: "westayin@fresh.onthestreets2",
        password: "123456", name: "boiicantkeepcomingupwiththesedumpstringtotestallofthesetestsjesus")

    user_email_too_small = User.new( username: "plsendme", email: "r@i.p",
        password: "123456", name: "joaolul" )
    user_email_too_large = User.new( username: "arentyoutiredyet", email: "itwontenddarksouls420mlgedition360noscopesonlyallday",
        password: "123456", name: "joaolul" )

    user_username_too_small = User.new( username: "h", email: "cabodaciolo@tarepreendido.com2",
      password: "123456", name: "joaolul" )
    user_username_too_large = User.new( username: "totallyuniquenamethatistoolargetobesavedinourdatabaseyouknowwhatimean",
      email: "cabodaciolo@tarepreendido.com", password: "123456", name: "joaolul" )

    assert_not user_repeated_email.valid?
    assert_not user_repeated_username.valid?

    assert_not user_without_username.valid?
    assert_not user_without_password.valid?
    assert_not user_without_email.valid?
    assert_not user_without_name.valid?

    assert_not user_name_too_small.valid?
    assert_not user_name_too_large.valid?
    assert_not user_email_too_small.valid?
    assert_not user_email_too_large.valid?
    assert_not user_username_too_small.valid?
    assert_not user_username_too_large.valid?
  end

  test "users with parameters that don't follow the required format shouldn't be created" do
    user_invalid_email = User.new( username: "webackbois", email: "invalid-_.email,com",
      password: "123456", name: "joaolul" )
    user_invalid_username = User.new( username: "we-back,bo_is", email: "valid@email.com",
      password: "123456", name: "joaolul" )
    user_invalid_name = User.new( username: "webackboisagain", email: "uniquevalid@email.com",
      password: "123456", name: "j-o,a.o_lul" )

    assert_not user_invalid_email.valid?
    assert_not user_invalid_username.valid?
    assert_not user_invalid_name.valid?
  end

  test "destroying a user should destroy their follows as well" do
    user_1 = User.first
    user_2 = User.find(2)
    user_3 = User.find(3)
    user_4 = User.find(4)
    user_5 = User.find(5)

    Relation.create(follower: user_1, followed: user_4)
    Relation.create(follower: user_2, followed: user_5)
    Relation.create(follower: user_3, followed: user_1)

    User.destroy(user_1.id)
    User.destroy(user_2.id)

    assert_not user_4.followers.include? user_1
    assert_not user_5.followed_users.include? user_2
    assert_not user_3.followed_users.include? user_1
  end

  test 'following a user should add a follow to the Relation table' do
    user_1 = User.find(1)
    user_2 = User.find(2)
    user_3 = User.find(3)
    user_4 = User.find(4)
    user_5 = User.find(5)

    user_4.follow(user_3.username)
    user_3.follow(user_4.username)
    user_1.follow(user_5.username)
    user_1.follow(user_2.username)
    user_1.follow(user_4.username)
    user_5.follow(user_1.username)
    user_5.follow(user_2.username)
    user_5.follow(user_3.username)
    user_3.follow(user_1.username)
    user_3.follow(user_2.username)

    assert user_3.followers.include?(user_4)
    assert user_4.followed_users.include?(user_3)

    assert user_4.followers.include?(user_3)
    assert user_3.followed_users.include?(user_4)

    assert user_5.followers.include?(user_1)
    assert user_1.followed_users.include?(user_5)

    assert user_2.followers.include?(user_1)
    assert user_1.followed_users.include?(user_2)

    assert user_4.followers.include?(user_1)
    assert user_1.followed_users.include?(user_4)

    assert user_1.followers.include?(user_5)
    assert user_5.followed_users.include?(user_1)

    assert user_2.followers.include?(user_5)
    assert user_5.followed_users.include?(user_2)

    assert user_3.followers.include?(user_5)
    assert user_5.followed_users.include?(user_3)

    assert user_1.followers.include?(user_3)
    assert user_3.followed_users.include?(user_1)

    assert user_2.followers.include?(user_3)
    assert user_3.followed_users.include?(user_2)
  end

  test "user shouldn't be able to follow itself" do
    user_1 = User.first
    self_follow = Relation.new(follower: user_1, followed: user_1)
    assert_not self_follow.valid?
  end

  test "two users shouldn't have more than one of the same relation between themselves" do
    user_1 = User.find(1)
    user_2 = User.find(2)
    user_3 = User.find(3)

    user_1.follow(user_2.username)
    user_1.follow(user_3.username)
    user_2.follow(user_3.username)
    user_2.follow(user_1.username)
    user_3.follow(user_1.username)
    user_3.follow(user_2.username)

    _1_follow_2_repeat = Relation.create(follower: user_1, followed: user_2)
    _1_follow_3_repeat = Relation.create(follower: user_1, followed: user_3)
    _2_follow_3_repeat = Relation.create(follower: user_2, followed: user_3)
    _2_follow_1_repeat = Relation.create(follower: user_2, followed: user_1)
    _3_follow_1_repeat = Relation.create(follower: user_3, followed: user_1)
    _3_follow_2_repeat = Relation.create(follower: user_3, followed: user_2)

    assert_not _1_follow_2_repeat.save
    assert_not _1_follow_3_repeat.save
    assert_not _2_follow_3_repeat.save
    assert_not _2_follow_1_repeat.save
    assert_not _3_follow_1_repeat.save
    assert_not _3_follow_2_repeat.save
  end

  test "there shouldn't be a relation involving invalid users" do
    user_1 = User.first
    invalid_username = "invalid_username"
    assert_not user_1.follow(invalid_username)
  end

  test "unfollowing should delete a relation from the database" do
    user_1 = User.find(1)
    user_2 = User.find(2)
    user_3 = User.find(3)

    user_1.follow(user_2.username)
    user_2.follow(user_3.username)
    user_3.follow(user_1.username)

    assert user_1.followed_users.include? user_2
    assert user_2.followed_users.include? user_3
    assert user_3.followed_users.include? user_1

    user_1.unfollow(user_2.username)
    user_2.unfollow(user_3.username)
    user_3.unfollow(user_1.username)

    assert_not user_1.followed_users.include? user_2
    assert_not user_2.followed_users.include? user_3
    assert_not user_3.followed_users.include? user_1
  end

  test "user liking/disliking a tweet should create/destroy a Like in the database and increment/decrement number_of_likes of said tweet" do
    user_1 = User.first
    tweet_to_be_liked = Tweet.first
    created_like = user_1.like(tweet_to_be_liked)
    tweet_to_be_liked.reload
    assert Like.exists?(created_like.id)
    assert_equal 1, tweet_to_be_liked.number_of_likes
    Like.destroy(created_like.id)
    tweet_to_be_liked.reload
    assert_equal 0, tweet_to_be_liked.number_of_likes
  end
end
