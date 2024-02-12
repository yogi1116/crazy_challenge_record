class PasswordResetsController < ApplicationController
  skip_before_action :require_login, only: %i[create edit update new]

  def new; end

  def create
    @user = User.find_by(email: params[:email])
    @user&.deliver_reset_password_instructions!
    redirect_to login_path, flash: { success: t('.success') }
  end

  def edit
    @token = params[:id]
    @user = User.load_from_reset_password_token(@token)
    not_authenticated if @user.blank?
  end

  def update
    @token = params[:id]
    @user = User.load_from_reset_password_token(@token)

    return not_authenticated if @user.blank?
    return if validation_reset_password

    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.change_password(params[:user][:password])
      redirect_to login_path, flash: { success: t('.success') }
      return
    else
      flash.now[:error] = t('.fail')
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def validation_reset_password
    if params[:user][:password].blank? || params[:user][:password_confirmation].blank?
      flash.now[:error] = t('.empty_password')
      render :edit, status: :unprocessable_entity
      return true
    end
    false
  end
end
