class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to posts_path
    else
      render post_path
    end
  end

  def edit
    @post = Post.find(params[:id])
    @post.save!
  end

  def show
    @post = Post.find(params[:id])
  end

  def destroy
    @post.destroy
  end

  private

  def post_params
    params.require(:post).permit(:name, :body)
  end
end
