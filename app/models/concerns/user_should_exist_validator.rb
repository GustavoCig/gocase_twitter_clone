class UserShouldExistValidator < ActiveModel::Validator
  def validate(record)
    if !User.exists?(record.user_id)
      record.errors.add(:user, " User is invalid or doesn't exist")
      # byebug
    end
  end
end