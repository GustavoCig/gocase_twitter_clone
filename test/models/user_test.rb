require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "if user with repeating ids are allowed" do
    new_user = User.new( email: "teste@teste_unique", encrypted_password: "123456" )
    assert_not new_user.save
  end

  test "if user with repeating emails are allowed" do
    new_user = User.new( email: User.first.email, encrypted_password: "123456" )
    assert_not new_user.save
  end

  test "if destroying a user destroy their follows as well" do
    user_1 = User.find(1)
    user_2 = User.find(2)
    user_3 = User.find(3)

    _1_follow_2 = Relation.create(follower: user_1, followed: user_2)
    _1_follow_3 = Relation.create(follower: user_1, followed: user_3)
    _2_follow_3 = Relation.create(follower: user_2, followed: user_3)
    _2_follow_1 = Relation.create(follower: user_2, followed: user_1)
    _3_follow_1 = Relation.create(follower: user_3, followed: user_1)
    _3_follow_2 = Relation.create(follower: user_3, followed: user_2)
  end

end
