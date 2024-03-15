class AiChatsController < ApplicationController
  def new; end

  def create
    service = OpenAiChatService.new([{role: "user", content: params[:body]}])
    @ai_response = service.chat
    respond_to do |format|
      format.turbo_stream
    end
  end
end
