class User < ApplicationRecord
  has_one_attached :avatar
  has_many_attached :media
  has_many :mentions, dependent: :destroy
  has_many :tweets, dependent: :destroy

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
  validates :name, length: { minimum: 2, maximum: 50 },
        format: { with: /\A[a-zA-Z0-9\s]{1,50}\z/,
        message: "Invalid name used" }
  validates :email, length: { minimum: 6, maximum: 30 },
        format: { with: /\A[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]{1,15}+@[a-zA-Z0-9]{1,15}+\.[a-zA-Z0-9]{1,5}+\z/,
        message: "Invalid email used" }
  validates :username, length: { minimum: 2, maximum: 30},
        format: { with: /\A[a-zA-Z0-9]{1,30}\z/,
        message: "Invalid username used" }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  
  def follow(username)
    if User.exists? username: username
      return Relation.create( follower: self, followed: User.find_by( username: username ) ) 
    end
    return false
  end

  def unfollow(username)
    if (( User.exists? username: username ) && ( followed_users.any?{ |row| row.username == username } ))
      return followed_users.destroy(User.find_by(username: username).id)
    end
    return false
  end

  def create_tweet(message)
    Tweet.create(user: self, message: message)
  end

  def like(tweet_id)
    Like.create(user: self, tweet_id: tweet_id)
  end
end
