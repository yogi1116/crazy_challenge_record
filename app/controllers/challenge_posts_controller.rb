class ChallengePostsController < ApplicationController
  include PostModerationConcern

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
    return if challenge_post_invalid
    return if challenge_content_moderated(@challenge_post)

    redirect_to challenge_posts_path, flash: { success: t('challenge_posts.create.success') } if @challenge_post.save!
  rescue => e
    handle_content_analysis_error(e)
  end

  def edit; end

  def update
    @challenge_post.assign_attributes(challenge_post_params) # 仮代入のためupdateメソッドは使わない
    return if challenge_post_invalid
    return if challenge_content_moderated(@challenge_post)

    redirect_to challenge_posts_path, flash: { success: t('challenge_posts.update.success') } if @challenge_post.save!
  rescue => e
    handle_content_analysis_error(e)
  end

  def destroy
    @challenge_post.challenge_post_categories.destroy_all
    @challenge_post.destroy!
    redirect_to challenge_posts_path, flash: { success: t('challenge_posts.destroy.success') }
  end

  private

  def challenge_post_params
    params.require(:challenge_post).permit(:title, :content, category_ids: [])
  end

  def find_challenge_post
    @challenge_post = ChallengePost.find(params[:id])
  end
end
