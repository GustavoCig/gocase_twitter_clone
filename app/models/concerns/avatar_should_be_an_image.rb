class AvatarShouldBeAnImage < ActiveModel::Validator
  def validate record
    puts record.avatar.content_type
    if !record.avatar.content_type.in? %w(image/jpeg image/png)
      record.errors.add :avatar, 'should be an image'
    end
  end
end