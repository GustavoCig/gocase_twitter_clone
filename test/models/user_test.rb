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
    # first_id = User.first.id
    # User.destroy(first_id)
    # assert_not Relation.find(first_id)
    # assert_not Relation.find_by(followed_id: first_id)
  end

end
