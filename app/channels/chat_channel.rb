class ChatChannel < ApplicationCable::Channel
  def subscribed
    receiver_id = params[:receiver_id].to_i
    private_chat_room = if current_user.id < receiver_id
                          "chat_channel_#{current_user.id}_#{receiver_id}"
                        else
                          "chat_channel_#{receiver_id}_#{current_user.id}"
                        end

    stream_from private_chat_room
  end
end
