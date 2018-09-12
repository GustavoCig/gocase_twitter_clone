class User < ApplicationRecord
  has_one_attached :avatar
  has_many_attached :media
  has_many :tweets

  # Defines the 'virtual' 'active' relation where the users with 'follower_id' are following somebody else
  has_many :active_relations, foreign_key: "follower_id",
                              class_name: "Relation",
                              dependent: :destroy
  has_many :followed_users, through: :active_relations, source: :followed

  # Defines the 'virtual' 'passive' relation where the users with 'followed_id' are the ones following somebody else
  has_many :passive_relations, foreign_key: "followed_id",
                               class_name: "Relation",
                               dependent: :destroy
  has_many :followers, through: :passive_relations, source: :follower

  validates :id, :email, uniqueness: true
  validates :id, :email, :name, :created_at, :updated_at, presence: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def follow(user)
    if User.exists?(email: user.email)
      followed_users << user
    end
    return false
  end

  def follow_by_email(user_email)
    if User.exists?(email: user_email)
      return followed_users << User.find_by(email: user_email)
    end
    return false
  end

  def unfollow(user)
    if User.exists?(email: user.email)
      return followed_users.destroy(user)
    end
    return false
  end

  def unfollow_by_email(user_email)
    if User.exists?(email: user_email)
      return followed_users.destroy(email: user_email)
    end
    return false
  end

end
