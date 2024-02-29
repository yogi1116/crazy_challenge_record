class Message < ApplicationRecord
  mount_uploader :image, MessageImageUploader

  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  validates :body, presence: true, length: {maximum: 500}
end
