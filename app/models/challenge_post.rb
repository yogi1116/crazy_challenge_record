class ChallengePost < ApplicationRecord
  belongs_to :user
  has_many :challenge_post_categories
  has_many :categories, through: :challenge_post_categories
  has_many :challenge_post_likes, dependent: :destroy
  has_many :liking_users, through: :challenge_post_likes, source: :user

  validates :title, presence: true
  validates :content, presence: true
  validates :category_ids, presence: { message: 'を選択してください' }
  validate :category_count_within_limit

  def self.ransackable_attributes(auth_object = nil)
    %w[category_ids challenge_post_likes_count]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[categories]
  end

  private

  def category_count_within_limit
    if category_ids.count > 3
      errors.add(:category_ids, 'は最大3つまでです')
    end
  end
end
