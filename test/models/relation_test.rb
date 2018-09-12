require 'test_helper'

class RelationTest < ActiveSupport::TestCase
  test 'if the follow relations are working properly' do
    user_1 = User.find(1)
    user_2 = User.find(2)
    user_3 = User.find(3)
    user_4 = User.find(4)
    user_5 = User.find(5)

    _4_follow_3 = Relation.create(follower: user_4, followed: user_3)
    _3_follow_4 = Relation.create(follower: user_3, followed: user_4)
    _1_follow_5 = Relation.create(follower: user_1, followed: user_5)
    _1_follow_2 = Relation.create(follower: user_1, followed: user_2)
    _1_follow_4 = Relation.create(follower: user_1, followed: user_4)
    _5_follow_1 = Relation.create(follower: user_5, followed: user_1)
    _5_follow_2 = Relation.create(follower: user_5, followed: user_2)
    _5_follow_3 = Relation.create(follower: user_5, followed: user_3)
    _3_follow_1 = Relation.create(follower: user_3, followed: user_1)
    _3_follow_2 = Relation.create(follower: user_3, followed: user_2)

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
end
