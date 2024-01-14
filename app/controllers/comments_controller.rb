class CommentsController < ApplicationController
  def create
    commet = current_user.comments.build(comment_params)
    if comment.save
      redirect_to post_path(comment.post)
    else
      redirect_to board_path(comment.post)
    end

  def update
    @comment = current_user.comments.find(params[:id])
    if @comment.update(comment_update_params)
      redirect_to post_path(comment.post)
    else
      redirect_to board_path(comment.post)
    end
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(board_id: params[:board_id])
  end
end
