class MessagesController < ApplicationController
  def index

  end

  def create

  end

  def show

  end

  def destory

  end

  private

  def message_params
    params.require(:message).permit(:body, :receiver_id)
  end
end
