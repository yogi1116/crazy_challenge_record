class UserSessionsController < ApplicationController
  skip_before_action :require_login

  def new; end

  def create
    @user = login(params[:email], params[:password])
    if @user
      session[:user_id] = @user.id
      redirect_back_or_to posts_path, success: t('.success')
    else
      flash.now[:error] = t('.fail')
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to root_path, status: :see_other, flash: { success: t('.success') }
  end
end
