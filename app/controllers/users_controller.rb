class UsersController < ApplicationController
  def new
		@user = User.new
  end

  def create
		@user = User.new(user_params)
    if @user.save
      redirect_to login_path, flash: { success: 'ユーザー登録が完了しました' }
    else
      flash.now[:error] = 'ユーザー登録に失敗しました'
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :username)
  end
end
