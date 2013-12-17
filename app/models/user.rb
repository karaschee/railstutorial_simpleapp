class User < ActiveRecord::Base
  # [:microposts] - 对应的表microposts, 属性名microposts, 外键user_id
  has_many :microposts, dependent: :destroy

  # [:relationships] - 对应的表Relationship, 属性名relationships
  # [foreign_key: "follower_id"] - 指定外键
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy

  # [:relationships] - 属性名reverse_relationships
  # [foreign_key: "followed_id"] - 指定外键
  # [class_name: "Relationship"] - 对应的表Relationship
  has_many :reverse_relationships, foreign_key: "followed_id", dependent: :destroy, class_name: "Relationship"

  # [:followeds] - 所取的Relationship关联followed, 属性名followeds
  # [through: :relationships] - 指定的User关联
  # has_many :followeds, through: :relationships

  # [:followed_users] - 自定义属性名称, 属性名followed_users
  # [through: :relationships] - 指定的User关联(代码第7行), 通过此关联可找到相应的表
  # [source: :followed] - 所取的Relationship关联followed, 根据此关联取得结果[relationship1.followed, relationship2.followed, ...],
  #                       ~ Relationship Model必须有belongs_to :followed...
  # PS: [foreign_key: "follower_id"]外键已经通过第7行的代码指定了
  # has_many :followed_users, through: :relationships, class_name: User, source: :followed
  has_many :followed_users, through: :relationships, source: :followed

  has_many :followers, through: :reverse_relationships


  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }
  has_secure_password

  before_save { email.downcase! } #self.email = email.downcase
  before_create :create_remember_token

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def feed
    # This is preliminary. See "Following users" for the full implementation.
    Micropost.where("user_id = ?", id)
    # microposts or self.microposts
  end

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy if following? other_user
  end

  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end