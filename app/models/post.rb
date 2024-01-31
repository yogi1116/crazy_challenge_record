class Post < ApplicationRecord
  alias_attribute :retry_value, :retry

  belongs_to :user
  has_many_attached :images
  has_many :post_categories
  has_many :categories, through: :post_categories
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :title, presence: true
  validates :content, presence: true
  validates :challenge_result, presence: true
  validates :retry, presence: { message: 'を選択してください' }, if: -> { challenge_result == 'give_up' }
  validate :image_count_within_limit
  validates :category_ids, presence: { message: 'を選択してください' }
  validate :category_count_within_limit

  enum challenge_result: { complete: 0, give_up: 1 }
  enum retry: { try: 0, no_try: 1 }

  def likes_count_by_button_type
    # ここに各ボタンタイプのいいね数を返すロジックを実装
    {
      'crazy_2' => self.likes.where(button_type: 'crazy').count,
      'fight_2' => self.likes.where(button_type: 'fight').count,
      'nice_fight_2' => self.likes.where(button_type: 'nice_fight').count,
    }
  end

  def self.ranking
    where(challenge_result: 'complete')
      .where('likes_count > 0')
      .order(likes_count: :desc)
      .limit(10)
      .includes(:user, { user: :profile }, :categories)
  end

  private

  def image_count_within_limit
    if images.length > 4
      errors.add(:images, 'に添付できる枚数は最大4枚です')
    end
  end

  def category_count_within_limit
    if category_ids.count > 3
      errors.add(:category_ids, 'は最大3つまでです')
    end
  end
end
