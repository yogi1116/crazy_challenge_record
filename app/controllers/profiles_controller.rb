class ProfilesController < ApplicationController
  def new;end

  def create
    @profile = Profile.new(profile_params)
    if @profile.save
      redirect_to profile_path
    else
      render :new
    end
  end

  def show; end

  def edit
  end

  def update
    if @profile.update(profile_params)
      redirect_to profile_path
    else
      render :edit
    end
  end

  private

  def profile_params
    params.require(:user).permit(:one_word, :birthday, :hobbies, :challenge,  :introduction, :avatar, :avatar_cache)
  end
end
