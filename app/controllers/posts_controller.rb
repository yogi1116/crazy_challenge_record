class PostsController < ApplicationController
  before_action :find_post, only: [:edit, :update, :destroy]

  def index
    @posts = Post.all
  end

  def new
    challenge_result = params[:challenge_result]
    @post = Post.new(challenge_result: Post.challenge_results[challenge_result])
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to posts_path
    else
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit; end

  def update
    if @post.update(post_params)
      redirect_to post_path(@post)
    else
      render :edit
    end
  end

  def destroy
    @post.destroy!
    redirect_to posts_path
  end

  private

  def post_params
    params.require(:post).permit(:challenge_result, :title, :content, :record, :category, :impression_event, :lesson, :retry, images: [])
  end

  def find_post
    @post = current_user.posts.find(params[:id])
  end
end
