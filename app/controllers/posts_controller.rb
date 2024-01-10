class PostsController < ApplicationController
  skip_before_action :require_login, only: [:index]
  before_action :find_post, only: [:edit, :update, :destroy]

  def index
    @posts = Post.with_attached_images.includes(:user, :categories).order(created_at: :desc)
  end

  def new
    challenge_result = params[:challenge_result]
    @post = Post.new(challenge_result: Post.challenge_results[challenge_result])
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to posts_path, flash: { success: t('posts.create.success') }
    else
      flash.now[:error] = t('.fail')
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @post = Post.find(params[:id])
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

  private

  def post_params
    params.require(:post).permit(:challenge_result, :title, :content, :record, :impression_event, :lesson, :retry, category_ids: [], images: [])
  end

  def find_post
    @post = current_user.posts.find(params[:id])
  end
end
