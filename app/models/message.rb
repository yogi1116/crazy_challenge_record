class Message < ApplicationRecord
  after_create_commit { MessageBroadcastJob.perform_later(self) }

  mount_uploader :image, MessageImageUploader

  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  validate :body_or_image_present
  validates :body, presence: true, length: { maximum: 500 }, if: -> { body.present? }

  private

  def body_or_image_present
    return if body.present? || image.present?
    errors.add(:base, "メッセージか画像のいずれかを入力してください")
  end
end
