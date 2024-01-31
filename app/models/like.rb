class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post, counter_cache: true

  validates :button_type, presence: true
end
