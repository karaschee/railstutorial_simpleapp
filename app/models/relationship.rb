class Relationship < ActiveRecord::Base
  # [:followed] - 指定外键followed, 属性名followed
  # [class_name: User] - 指定对应表
  belongs_to :followed, class_name: User
  belongs_to :follower, class_name: User
  # belongs_to :user, :foreign_key => 'followed_id'
  # belongs_to :user, :foreign_key => 'follower_id'

  validates :follower_id, presence: true
  validates :followed_id, presence: true
end
