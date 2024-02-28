class MessagesController < ApplicationController
  def index

  end

  def create
    @message = current_user.sent_messages.build(message_params)
    @message.sent_at = Time.current
    if @message.save
      ChatChannel.broadcast_to(
        @message.receiver,
        { message: @message.as_json, type: 'message' }
      )
    else
      ChatChannel.broadcast_to(
        current_user,
        { error: @message.errors.full_messages.to_sentence }
      )
    end
  end

  def show
    receiver_id = User.find_id_by_uuid(params[:id])
    @receiver = User.find(receiver_id)
    @messages = Message.where("(sender_id = ? AND receiver_id = ?) OR (sender_id = ? AND receiver_id = ?)",
                              current_user.id, receiver_id, receiver_id, current_user.id)
    @message = Message.new
    @message.receiver_id = @receiver.id
  end

  private

  def message_params
    params.require(:message).permit(:body, :receiver_id, :sent_at)
  end
end
