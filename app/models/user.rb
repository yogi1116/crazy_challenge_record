class User < ApplicationRecord
  authenticates_with_sorcery!
  after_create :create_user_profile

  has_one :profile, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post
  has_many :comments, dependent: :destroy
  has_many :authentications, :dependent => :destroy
  has_many :sent_messages, class_name: 'Message', foreign_key: 'sender_id'
  has_many :received_messages, class_name: 'Message', foreign_key: 'receiver_id'
  has_many :challenge_posts, dependent: :destroy
  has_many :challenge_post_likes, dependent: :destroy
  has_many :liked_posts, through: :challenge_post_likes, source: :challenge_post

  accepts_nested_attributes_for :authentications

  validates :username, presence: true, length: { maximum: 40 }
  validates :email, presence: true, uniqueness: true, unless: :social_login?
  validates :password, length: { minimum: 5 }, format: { with: /\A(?=.*?\d)(?=.*?[a-zA-Z])/, message: 'は英数字をそれぞれ1種類以上含む必要があります' }, if: :password_required?
  validates :password, presence: true, confirmation: true, if: :password_required?
  validates :password_confirmation, presence: true, if: :password_required?
  validates :reset_password_token, presence: true, uniqueness: true, allow_nil: true
  validates_acceptance_of :agreement, allow_nil: false, on: :create

  def social_login?
    authentications.any?
  end

  def own?(object)
    id == object.user_id
  end

  def like?(post)
    liked_posts.include?(post)
  end

  def like(post)
    liked_posts << post
  end

  def unlike(post)
    liked_posts.destroy(post)
  end

  # パラメータからidを取得する際はuuidがデフォルト
  def to_param
    uuid
  end

  # uuidをidに変換
  def self.find_id_by_uuid(uuid)
    find_by(uuid: uuid)&.id
  end

  private

  def create_user_profile
    build_profile.save
  end

  # パスワードが必要かどうかを判断するメソッド
  def password_required?
    !social_login? && (new_record? || password.present? || password_confirmation.present?)
  end
end
