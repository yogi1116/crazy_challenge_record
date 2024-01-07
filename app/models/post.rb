class Post < ApplicationRecord
  belongs_to :user
  has_many_attached :images

  validates :title, presence: true
  validates :content, presence: true
  validates :category, presence: true
  validates :retry, presence: true, if: -> { challenge_result == 'give_up' }
  validate :image_count_within_limit

  enum challenge_result: { complete: 0, give_up: 1 }
  enum category: { sports: 0, patience: 1, study: 2 }
  enum retry: { try: 0, no_try: 1 }

  private

  def image_count_within_limit
    if images.length > 4
      errors.add(:images, 'に添付できるのは大4枚までです。')
    end
  end
end
