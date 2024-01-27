class ApplicationController < ActionController::Base
  before_action :require_login
  before_action :set_profile

  private

  def not_authenticated
    flash[:notice] = t('defaults.require_login')
    redirect_to login_path
  end

  def set_profile
    @profile = current_user.profile if logged_in?
  end
end
