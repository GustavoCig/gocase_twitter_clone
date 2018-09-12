require 'test_helper'

class RelationTest < ActiveSupport::TestCase
  test 'if the follow relations are working properly' do
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

  test "if user can't follow itself" do
  end

  test "if two users can't have more than one of the same relation between themselves" do
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

  test "if there can't be a relation involving invalid users" do
    user_1 = User.first
    invalid_username = "invalid_username"
    assert_not user_1.follow(invalid_username)
  end

  test "if the unfollow methods are working" do

  end
end
