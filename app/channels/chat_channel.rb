class ChatChannel < ApplicationCable::Channel
  def subscribed
    sender_id = current_user.id
    receiver_id = params[:receiver_id]
    conversation_id = [sender_id, receiver_id].sort.join("_")

    stream_from "conversation_#{conversation_id}"
  end
end
