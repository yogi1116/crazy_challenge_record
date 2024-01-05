class Post < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :content, presence: true
  enum challenge_result: { complet: 0, give_up: 1 }
  enum retry: { try: 0, "don't_try": 1 }
end
