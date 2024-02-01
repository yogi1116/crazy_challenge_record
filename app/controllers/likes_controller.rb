class LikesController < ApplicationController
  before_action :find_post, only: %i[create destroy]

  def create
    button_type = determine_button_type(@post)
    current_user.likes.create(post: @post, button_type: button_type)
  end

  def destroy
    @like = current_user.likes.find_by(id: params[:id])
    @like&.destroy
  end

  private

  def find_post
    @post = Post.find(params[:post_id])
  end

  def determine_button_type(post)
    if post.challenge_result == 'complete'
      'crazy'
    elsif post.challenge_result == 'give_up'
      post.retry == 'try' ? 'fight' : 'nice_fight'
    end
  end
end
