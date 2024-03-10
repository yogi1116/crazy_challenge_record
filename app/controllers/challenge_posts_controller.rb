class ChallengePostsController < ApplicationController
  skip_before_action :require_login, only: %i[index]
  before_action :find_challenge_post, only: %i[edit update destroy]

  def index
    @challenge_posts = ChallengePost.all
  end

  def new
    @challenge_post = ChallengePost.new
  end

  def create
    @challenge_post = current_user.challenge_posts.build(challenge_post_params)
    if @challenge_post.save
      redirect_to challenge_posts_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @challenge_post.update(challenge_post_params)
      redirect_to challenge_posts_path
    else
      render :edit
    end
  end

  def destroy
    @challenge_post.destroy
  end

  private

  def challenge_post_params
    params.require(:challenge_post).permit(:title, :content)
  end

  def find_challenge_post
    @challenge_post = ChallengePost.find(params[:id])
  end
end
