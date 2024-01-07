class Post < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :content, presence: true
  validates :category, presence: true
  validates :retry, presence: true, if: -> { challenge_result == 'give_up' }

  enum challenge_result: { complet: 0, give_up: 1 }
  enum category: { sports: 0, patience: 1, study: 2 }
  enum retry: { try: 0, no_try: 1 }
end
