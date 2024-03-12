class ChallengePostLikesController < ApplicationController
  before_action :find_challenge_post, only: %i[create destroy]

  def create
    current_user.challenge_post_likes.create(challenge_post: @challenge_post)
  end

  def destroy
    @like = current_user.challenge_post_likes.find_by(id: params[:id])
    @challenge_post = @like.challenge_post if @like
    @like&.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to challenge_posts_path, notice: "いいねを解除しました。" }
    end
  end

  private

  def find_challenge_post
    @challenge_post = ChallengePost.find(params[:challenge_post_id])
  end
end
