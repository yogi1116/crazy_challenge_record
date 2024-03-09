class ChatChannel < ApplicationCable::Channel
  def subscribed
    receiver_id = params[:receiver_id].to_i
    private_chat_room = Message.private_chat_room_name(current_user.id, receiver_id)

    stream_from private_chat_room
  end
end
