class Post < ApplicationRecord
  validates :name, :body, presence: true
end
