class Message < ApplicationRecord
  mount_uploader :image, MessageImageUploader

  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  validates :body, presence: true, length: { maximum: 300 }, if: -> { body.present? }

  def self.private_chat_room_name(user1_id, user2_id)
    if user1_id < user2_id
      "chat_channel_#{user1_id}_#{user2_id}"
    else
      "chat_channel_#{user2_id}_#{user1_id}"
    end
  end
end
