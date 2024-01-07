class PostsController < ApplicationController
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
    params.require(:post).permit(:challenge_result, :title, :content, :record, :category, :impression_event, :lesson, :feedback, :retry)
  end
end
