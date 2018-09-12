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

  validates :id, :username, :email, uniqueness: true
  validates :id, :username, :email, :name, :created_at, :updated_at, presence: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  def follow(username)
    if User.exists? username: username
      return followed_users << User.find_by(username: username)
    end
    return false
  end

  def unfollow(username)
    if (( User.exists? username: username ) && ( followed_users.include? username: username ))
      return followed_users.destroy(username: username)
    end
    return false
  end

end
