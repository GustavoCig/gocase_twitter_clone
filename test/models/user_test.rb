require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "if user with repeating ids are allowed" do
    new_user = User.new( id: User.first.id,
                         email: "teste@teste_unique",
                         encrypted_password: "123456",
                         created_at: "2018-09-06 14:15:49",
                         updated_at: "2018-09-06 14:15:49" )
    assert_not new_user.save
  end

  test "if user with repeating emails are allowed" do
    new_user = User.new( id: User.last.id + 1,
                         email: User.first.email,
                         encrypted_password: "123456",
                         created_at: "2018-09-06 14:15:49",
                         updated_at: "2018-09-06 14:15:49" )
    assert_not new_user.save
  end
end
