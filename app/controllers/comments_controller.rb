class CommentsController < ApplicationController
  before_action :set_post, only: %i[create edit update destroy]

  def create
    @comment = @post.comments.build(comment_params.merge(user: current_user))
    if @comment.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to post_path(@post) }
      end
    else
      @comments = @post.comments.includes(:user).order(created_at: :desc)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update('comments-error', partial: 'shared/error_messages', locals: { object: @comment })
        end
        format.html { render 'posts/show' }
      end
    end
  end

  def edit
    @comment = current_user.comments.find(params[:id])
  end

  def update
    @comment = current_user.comments.find(params[:id])
    if @comment.update(comment_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to post_path(@post) }
      end
    else
      @comments = @post.comments.includes(:user).order(created_at: :desc)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update('comments-error', partial: 'shared/error_messages', locals: { object: @comment })
        end
        format.html { render 'posts/show' }
      end
    end
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
