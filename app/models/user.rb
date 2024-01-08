class User < ApplicationRecord
  authenticates_with_sorcery!
  after_create :create_user_profile

  has_one :profile, dependent: :destroy
  has_many :posts, dependent: :destroy

  validates :username, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 8 }, format: { with: /\A(?=.*?[a-z])(?=.*?[A-Z])(?=.*?\d)/, message: 'は大文字、小文字、数字をそれぞれ1種類以上含む必要があります' }
  validates :password, presence: true, confirmation: true
  validates :password_confirmation, presence: true

  def own?(object)
    id == object.user_id
  end

  private

  def create_user_profile
    build_profile.save
  end
end
