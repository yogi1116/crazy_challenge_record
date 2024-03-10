class ChallengePostsController < ApplicationController
  skip_before_action :require_login, only: %i[index]
  before_action :find_challenge_post, only: %i[edit update destroy]

  def index
    @challenge_posts = ChallengePost.includes(:categories, user: :profile).all
  end

  def new
    @challenge_post = ChallengePost.new
  end

  def create
    @challenge_post = current_user.challenge_posts.build(challenge_post_params)
    if @challenge_post.save
      redirect_to challenge_posts_path
    else
      render :new, status: :unprocessable_entity
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
    @challenge_post.challenge_post_categories.destroy_all
    @challenge_post.destroy!
    redirect_to challenge_posts_path, flash: { success: t('posts.destroy.success') }
  end

  private

  def challenge_post_params
    params.require(:challenge_post).permit(:title, :content, category_ids: [])
  end

  def find_challenge_post
    @challenge_post = ChallengePost.find(params[:id])
  end
end
