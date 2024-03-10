class ChallengePostsController < ApplicationController
  skip_before_action :require_login, only: %i[index]

  def index

  end

  def new

  end

  def create

  end

  def edit

  end

  def update

  end

  def destroy

  end

  private

  def challege_post_params
    params.require(:challenge_post).permit(:title, :content)
  end
end
