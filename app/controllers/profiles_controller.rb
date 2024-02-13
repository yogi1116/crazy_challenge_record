class ProfilesController < ApplicationController
  before_action :set_profile, only: %i[show edit update]

  def show; end

  def edit; end

  def update
    if @profile.update(profile_params)
      redirect_to profile_path, flash: { success: t('profiles.update.success') }
    else
      flash.now[:error] = t('.fail')
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_profile
    user_uuid = params[:user_uuid] || current_user.uuid
    @user = User.find_by(uuid: user_uuid)
    @profile = @user.profile
  end

  def profile_params
    params.require(:profile).permit(
      :one_word, :birthday, :hobbies, :challenge, :introduction,
      :avatar, :avatar_cache, :background, :background_cache,
      :profile_attribute, user_attributes: [:username, :id]
    )
  end
end
