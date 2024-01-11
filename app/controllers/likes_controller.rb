class LikesController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    button_type = determine_button_type(@post)
  
    like = current_user.likes.create(post: @post, button_type: button_type)
    if like.persisted?
      redirect_back fallback_location: root_path
    end
  end
  
  def destroy
    @like = current_user.likes.find_by(post_id: params[:id])
    @like.destroy if @like
    redirect_back fallback_location: root_path
  end
  
  private
  
  def determine_button_type(post)
    if post.challenge_result == 'complete'
      'crazy'
    elsif post.challenge_result == 'give_up'
      post.retry == 'try' ? 'stop' : 'nice_fight'
    end
  end
end
