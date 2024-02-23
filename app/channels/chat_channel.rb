class ChatChannel < ApplicationCable::Channel
  def subscribed
    conversation_id = [current_user.id, params[:receiver_id]].sort.join("_")
    stream_from "conversation_#{conversation_id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    request = Message.find(data['request_id'])
    user = User.find(data['user_id'])

    message = messages.create(body: data['message'], user: user)

    # 保存されたメッセージをブロードキャスト
    ChatChannel.broadcast_to(message, {
      user_id: user.id,
      user_name: user.profile.name,
      created_at: message.formatted_created_at,
      body: message.body
                              })
  end
end
