class User < ApplicationRecord
  has_one_attached :avatar
  has_many_attached :media
  has_many :mentions, dependent: :destroy
  has_many :tweets, dependent: :destroy

  # TODO: 
  # Use a regex to restrict the characters in a Users's username, name and email
  # 
  # Define if interface is going to use username or the user itself


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

  validates :username, :email, uniqueness: true
  validates :username, :email, :name, presence: true

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
    if (( User.exists? username: username ) && ( followed_users.any?{|row| row.username == username} ))
      return followed_users.destroy(User.find_by(username: username).id)
    end
    return false
  end

  def create_tweet(message)
    Tweet.create(user: self, message: message)
  end
end
