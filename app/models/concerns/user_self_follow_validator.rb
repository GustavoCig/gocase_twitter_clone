class UserSelfFollowValidator < ActiveModel::Validator
  def validate record
    if record.follower_id == record.followed_id
      record.errors.add :user, 'is not allowed to follow itself'
    end
  end
end