class ChallengePostsController < ApplicationController
  include PostModerationConcern

  skip_before_action :require_login, only: %i[index reset_search]
  before_action :restore_search_conditions, only: [:index]
  before_action :find_challenge_post, only: %i[edit update destroy]

  def index
    @q = ChallengePost.ransack(params[:q])
    @challenge_posts = @q.result(distinct: true)
                        .includes(:categories, user: :profile)
                        .page(params[:page]).per(16)

    if params[:category_ids_in].present? && Category.exists?(id: params[:category_ids_in])
      @challenge_posts = @challenge_posts.joins(:categories).where(categories: { id: params[:category_ids_in] })
    end

    if params[:q] && params[:q][:s].present?
      order_condition = params[:q][:s]
      @challenge_posts = @challenge_posts.reorder(order_condition)
    else
      @challenge_posts = @challenge_posts.order('challenge_posts.created_at DESC')
    end
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

  def reset_search
    session.delete(:q)
    session.delete(:category_ids_in)
    redirect_to challenge_posts_path
  end

  private

  def challenge_post_params
    params.require(:challenge_post).permit(:title, :content, category_ids: [])
  end

  def find_challenge_post
    @challenge_post = ChallengePost.find(params[:id])
  end

  def restore_search_conditions
    %i[q category_ids_in].each do |key|
      if params[key].present?
        session[key] = params[key]
      elsif session[key].present?
        params[key] = session[key]
      end
    end
  end
end
