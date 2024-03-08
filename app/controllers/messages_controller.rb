class MessagesController < ApplicationController
  skip_before_action :require_login

  def index
    sent_messages = current_user.sent_messages.select(:receiver_id).distinct
    received_messages = current_user.received_messages.select(:sender_id).distinct

    user_ids = sent_messages.pluck(:receiver_id) + received_messages.pluck(:sender_id)
    user_ids.uniq!

    @users_with_last_message = user_ids.map do |user_id|
      user = User.find(user_id)
      last_message = Message.where(sender: [current_user, user], receiver: [current_user, user]).order(created_at: :desc).first
      { user: user, last_message: last_message }
    end
  end

  def create
    @message = current_user.sent_messages.build(message_params)
    @message.sent_at = Time.current
    if @message.save
      receiver_id = @message.receiver_id
      sender_id = current_user.id
      private_chat_room = Message.private_chat_room_name(sender_id, receiver_id)
      ActionCable.server.broadcast private_chat_room, { message: render_message(@message, current_user) }
    else
      
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
    params.require(:message).permit(:body, :receiver_id, :sent_at, :image)
  end

  def render_message(message, current_user)
    ApplicationController.renderer.render(partial: 'messages/message', locals: { message: message, current_user: current_user })
  end
end
