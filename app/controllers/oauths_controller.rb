class OauthsController < ApplicationController
  skip_before_action :require_login

  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]
    if (@user = login_from(provider))
      redirect_to posts_path
    else
      begin
        @user = create_from(provider)
        reset_session
        auto_login(@user)
        redirect_to root_path
      rescue StandardError
        redirect_to root_path
    end
  end

  private

  def auth_params
    params.permit(:code, :provider, :error, :state)
  end
end
