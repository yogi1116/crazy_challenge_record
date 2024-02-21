class MessagesController < ApplicationController
  def index

  end

  def create

  end

  def show
    receiver_id = User.find_id_by_uuid(params[:id])
    @receiver = User.find(receiver_id)
    @messages = Message.where("(user_id = ? AND receiver_id = ?) OR (user_id = ? AND receiver_id = ?)", current_user.id, receiver_id, receiver_id, current_user.id)
  end

  def destory

  end

  private

  def message_params
    params.require(:message).permit(:body, :receiver_id)
  end
end
