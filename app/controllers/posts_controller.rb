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
      ridirect_to posts_path
    else
      render post_path
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
  end
end
