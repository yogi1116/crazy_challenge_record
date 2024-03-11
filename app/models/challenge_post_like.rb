class ChallengePostLike < ApplicationRecord
  belongs_to :user
  belongs_to :challenge_post, counter_cache: true
end