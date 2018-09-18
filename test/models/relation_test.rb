require 'test_helper'

class RelationTest < ActiveSupport::TestCase
  test "invalid/null parameters shouldn't create a relation" do
    user_1 = User.first
    invalid_user_id = User.last.id + 1
    invalid_user = User.new()

    invalid_user_id_relation = Relation.new(follower: user_1, followed_id: invalid_user_id)
    invalid_user_relation = Relation.new(follower: user_1, followed: invalid_user)
    one_parameter_null_relation = Relation.new(follower: user_1)
    
    assert_not invalid_user_id_relation.valid?
    assert_not invalid_user_relation.valid?
    assert_not one_parameter_null_relation.valid?
  end

  test "multiple equal relations shouldn't be allowed" do
    follower = User.first
    followed = User.find(2)

    Relation.create(follower: follower, followed: followed)
    repeated_relation = Relation.new(follower: follower, followed: followed)

    assert_not repeated_relation.valid?
  end

  test "self relations shouldn't be allowed" do
    self_relating_user = User.first

    self_relation = Relation.new(follower: self_relating_user, followed: self_relating_user)

    assert_not self_relation.valid?
  end
end
