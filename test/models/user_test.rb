require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # TODO:
  # Complete tests for user
  # Needs to finish test for destroying a user
  test "users with repeating ids shouldn't be allowed" do
    new_user = User.new( email: "teste@teste_unique", encrypted_password: "123456" )
    assert_not new_user.valid?
  end

  test "users with repeating emails shouldn't be allowed" do
    new_user = User.new( email: User.first.email, encrypted_password: "123456" )
    assert_not new_user.valid?
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

  test "invalid parameters shouldn't be accepted" do

  end

end
