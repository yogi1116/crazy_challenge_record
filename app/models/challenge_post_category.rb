class ChallengePostCategory < ApplicationRecord
  belongs_to :challenge_post
  belongs_to :category
end