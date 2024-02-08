class User < ApplicationRecord
  authenticates_with_sorcery!
  after_create :create_user_profile

  has_one :profile, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post
  has_many :comments, dependent: :destroy
  has_many :authentications, :dependent => :destroy
  accepts_nested_attributes_for :authentications

  validates :username, presence: true, length: { maximum: 40 }
  validates :email, presence: true, uniqueness: true, unless: :social_login?
  validates :password, length: { minimum: 5 }, format: { with: /\A(?=.*?\d)(?=.*?[a-zA-Z])/, message: 'は英数字をそれぞれ1種類以上含む必要があります' }, if: :password_required?
  validates :password, presence: true, confirmation: true, if: :password_required?
  validates :password_confirmation, presence: true, if: :password_required?
  validates_acceptance_of :agreement, allow_nil: false, on: :create

  def social_login?
    provider.present?
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

  private

  def create_user_profile
    build_profile.save
  end

  private

  # パスワードが必要かどうかを判断するメソッド
  def password_required?
    !social_login? && (new_record? || password.present? || password_confirmation.present?)
  end
end
