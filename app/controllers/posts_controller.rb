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
    @post = current_user.posts.build(post_params)
    if @post.invalid?
      flash.now[:error] = t('.fail')
      render :new, status: :unprocessable_entity
      return
    end
    @post.images.purge # オリジナル画像とリサイズ画像の両方を保存させないため

    full_text = generate_full_text(@post) # APIの呼び出し
    if content_moderated?(full_text)
      flash.now[:error] = moderation_message
      render :new, status: :unprocessable_entity
      return
    end

    attach_resized_images(params[:post][:images].reject(&:blank?)) if params[:post][:images].reject(&:blank?).present?

    if @post.save!
      redirect_to posts_path, flash: { success: t('posts.create.success') }
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
    @post.update(post_params)
    if @post.invalid?
      flash.now[:error] = t('.fail')
      render :edit, status: :unprocessable_entity
      return
    end

    images = params[:post][:images].present? ? params[:post][:images].reject(&:blank?) : []
    # 既存の画像を削除
    @post.images.purge if params[:post][:images].present?
    # アップロードされた画像をリサイズしてアタッチ
    attach_resized_images(images)


    full_text = generate_full_text(@post)

    # APIを呼び出して内容が適切かチェック
    if content_moderated?(full_text)
      # 問題があった場合、編集画面に戻す
      flash.now[:error] = moderation_message
      render :edit, status: :unprocessable_entity
      return
    else
      redirect_to post_path(@post), flash: { success: t('posts.update.success') }
    end
  rescue => e
    handle_content_analysis_error(e)
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

  def callback
    # OAuth認証の結果を受け取り、必要な情報をセッションに保存
    # ここでは例として、セッションに投稿のIDを保存するコードを書く
    session[:id] = params[:id] # 仮のコード
    
    # 認証が完了したら、編集ページにリダイレクト
    redirect_to edit_post_path(session[:id])
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
    images.each do |image|
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
