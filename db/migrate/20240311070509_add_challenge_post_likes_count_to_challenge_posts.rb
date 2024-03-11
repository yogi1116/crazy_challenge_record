class AddChallengePostLikesCountToChallengePosts < ActiveRecord::Migration[7.1]
  def change
    add_column :challenge_posts, :challenge_post_likes_count, :integer, default: 0, null: false
  end
end
