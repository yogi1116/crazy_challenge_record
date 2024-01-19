class Post < ApplicationRecord
  belongs_to :user
  has_many_attached :images
  has_many :post_categories
  has_many :categories, through: :post_categories
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :title, presence: true
  validates :content, presence: true
  validates :challenge_result, presence: true
  validates :retry, presence: true, if: -> { challenge_result == 'give_up' }
  validate :image_count_within_limit
  validates :category_ids, presence: { message: 'を選択してください' }

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

  private

  def image_count_within_limit
    if images.length > 4
      errors.add(:images, 'に添付できるのは大4枚までです。')
    end
  end
end
