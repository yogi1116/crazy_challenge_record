class AiChatsController < ApplicationController
  before_action :check_session_expiration

  def new
    @chat_bodies = session[:chat_body]
  end

  def create
    service = OpenAiChatService.new([{role: "user", content: params[:body]}])
    @ai_response = service.chat

    session[:chat_body] ||= []
    session[:chat_body] << {user: params[:body], ai: @ai_response}
    session[:expires_at] ||= Time.current.end_of_day.to_i

    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def check_session_expiration
    if session[:expires_at].present? && Time.current.to_i > session[:expires_at]
      reset_session
    end
  end
end
