class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def new
    @post = Post.new(post_params)
  end

  def create
    if @post.save
      redirect_to posts_path
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @post.update
      redirect_to post_path
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
    params.require(:post).permit(:challenge_result, :title, :content, :record, :impression_event, :lesson, :feedback, :retry)
  end
end
