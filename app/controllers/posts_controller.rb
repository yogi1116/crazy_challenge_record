class PostsController < ApplicationController
  include ImageProcessingConcern
  include PostModerationConcern

  skip_before_action :require_login, only: %i[index ranking reset_search]
  before_action :restore_search_conditions, only: [:index]
  before_action :find_post, only: %i[edit update destroy]

  def index
    @q = Post.ransack(params[:q])
    @posts = @q.result.includes(images_attachments: :blob, user: :profile)
                .order(created_at: :desc)
                .page(params[:page]).per(16)

    if params[:category_ids_in].present? && Category.exists?(id: params[:category_ids_in])
      @posts = @posts.joins(:categories).where(categories: { id: params[:category_ids_in] })
    end
  end

  def new
    challenge_result = params[:challenge_result]
    @post = Post.new(challenge_result: Post.challenge_results[challenge_result])
  end

  def create
    @post = current_user.posts.build(post_params.except(:images))
    full_text = generate_full_text(@post)

    if content_moderated?(full_text)
      flash.now[:error] = moderation_message
      render :new, status: :unprocessable_entity
      return
    end

    attach_resized_images(params[:post][:images]) if params[:post][:images].present?

    if @post.save
      redirect_to posts_path, flash: { success: t('posts.create.success') }
    else
      flash.now[:error] = t('.fail')
      render :new, status: :unprocessable_entity
    end
  rescue => e
    handle_content_analysis_error(e)
  end

  def show
    @post = Post.includes(images_attachments: :blob).find(params[:id])
    @comment = @comment.present? && @comment.errors.any? ? @comment : Comment.new
    @comments = @post.comments.includes(:user).order(created_at: :desc)
  end

  def edit; end

  def update
    images = params[:post][:images].present? ? params[:post][:images].reject(&:blank?) : []
    # 既存の画像を削除
    @post.images.purge
    # アップロードされた画像をリサイズしてアタッチ
    attach_resized_images(images)

    if @post.update(post_params.except(:images))
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

  def reset_search
    session.delete(:q)
    session.delete(:category_ids_in)
    redirect_to posts_path
  end

  private

  def restore_search_conditions
    [:q, :category_ids_in].each do |key|
      if params[key].present?
        session[key] = params[key]
      elsif session[key].present?
        params[key] = session[key]
      end
    end
  end

  def attach_resized_images(images)
    images.reject(&:blank?).each do |image|
      resized_image_attributes = process_image(image, width: 800, height: 800)
      @post.images.attach(resized_image_attributes) if resized_image_attributes
    end
  end

  def post_params
    params.require(:post).permit(
      :challenge_result, :title, :content, :record, :impression_event,
      :lesson, :retry, category_ids: [], images: []
    )
  end

  def find_post
    @post = current_user.posts.includes(images_attachments: [:blob]).find(params[:id])
  end
end
