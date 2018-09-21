class UserShouldExistValidator < ActiveModel::Validator
  def validate record
    if !User.exists? record.user_id
      record.errors.add :user, 'is invalid or doesn`t exist'
    end
  end
end