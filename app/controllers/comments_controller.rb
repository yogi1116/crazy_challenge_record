class CommentsController < ApplicationController
  before_action :set_post, only: %i[create update destroy]

  def create
    @comment = @post.comments.build(comment_params.merge(user: current_user))
    if @comment.save!
      redirect_to posts_path
    end
  end

  def update
    @comment = @post.comments.find(params[:id])
    @comment.update(comment_params)
  end

  def destroy
    @comment = @post.comments.find(params[:id])
    @comment.destroy!
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:body).merge(post_id: params[:post_id])
  end
end
