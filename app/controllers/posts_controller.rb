class PostsController < ApplicationController
  skip_before_action :require_login, only: %i[index ranking]
  before_action :find_post, only: %i[edit update destroy]

  def index
    @posts = Post.includes(images_attachments: :blob, user: :profile).order(created_at: :desc).page(params[:page]).per(16)
  end

  def new
    challenge_result = params[:challenge_result]
    @post = Post.new(challenge_result: Post.challenge_results[challenge_result])
  end

  def create
    @post = current_user.posts.build(post_params)
    if content_moderated?(@post.content) # 不適切な投稿
      flash.now[:error] = moderation_message
      render :new, status: :unprocessable_entity
    elsif @post.save
      redirect_to posts_path, flash: { success: t('posts.create.success') }
    else
      flash.now[:error] = t('.fail')
      render :new, status: :unprocessable_entity
    end
  rescue => e
    handle_content_analysis_error(e)
  end

  def show
    @post = Post.find(params[:id])
    @comment = @comment.present? && @comment.errors.any? ? @comment : Comment.new
    @comments = @post.comments.includes(:user).order(created_at: :desc)
  end

  def edit; end

  def update
    if @post.update(post_params)
      redirect_to post_path(@post), flash: { success: t('posts.update.success') }
    else
      flash.now[:error] = t('.fail')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.post_categories.destroy_all
    @post.destroy!
    redirect_to posts_path, flash: { success: t('posts.destroy.success') }
  end

  def ranking
    @posts = Post.ranking
  end

  private

  def content_moderated?(content)
    moderation_service = ContentModerationService.new(content)
    result = moderation_service.analyze
    categories = result['moderationCategories'].to_a
    @high_confidence_categories = categories.select { |category| category['confidence'] > 0.8 }
    @high_confidence_categories.any?
  end

  def moderation_message
    inappropriate_content = @high_confidence_categories.map { |category| t("moderation_categories.#{category['name']}") }.join('・ ')
    "不適切なコンテンツが含まれています：#{inappropriate_content}"
  end

  def handle_content_analysis_error(e)
    logger.error(e.message)
    flash.now[:error] = 'Content analysis failed.'
    render :new, status: :unprocessable_entity
  end

  def post_params
    params.require(:post).permit(
      :challenge_result, :title, :content, :record, :impression_event,
      :lesson, :retry, category_ids: [], images: []
    )
  end

  def find_post
    @post = current_user.posts.find(params[:id])
  end
end
