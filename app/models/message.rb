class Message < ApplicationRecord
  belongs_to :user
  belongs_to :receiver, class_name: 'User'

  validates :body, presence: true, length: {maximum: 500}
end
