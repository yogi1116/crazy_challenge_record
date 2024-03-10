class Category < ApplicationRecord
  has_many :post_categories
  has_many :posts, through: :post_categories
  has_many :challenge_post_categories
  has_many :challenge_posts, through: :challenge_post_categories
end
