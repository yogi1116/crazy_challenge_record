class TopPagesController < ApplicationController
  skip_before_action :require_login
  
  def top; end

  def privacy_policy; end
end
