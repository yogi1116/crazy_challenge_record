class ChallengePostLikesController < ApplicationController
  before_action :find_challenge_post, only: %i[create destroy]

  def create
    current_user.challenge_post_likes.create(challenge_post: @challenge_post)
  end

  def destroy
    @like = current_user.challenge_post_likes.find_by(id: params[:id])
    @like&.destroy
  end

  private

  def find_challenge_post
    @challenge_post = ChallengePost.find(params[:challenge_post_id])
  end
end
