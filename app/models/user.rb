class User < ApplicationRecord
  authenticates_with_sorcery!
  after_create :create_user_profile

  has_one :profile, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post
  has_many :comments, dependent: :destroy

  validates :username, presence: true, length: { maximum: 40 }
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 5 }, format: { with: /\A(?=.*?\d)(?=.*?[a-zA-Z])/, message: 'は英数字をそれぞれ1種類以上含む必要があります' }
  validates :password, presence: true, confirmation: true
  validates :password_confirmation, presence: true

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
end
