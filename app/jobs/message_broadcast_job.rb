class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message, user)
    sorted_ids = [message.sender_id, message.receiver_id].sort
    ActionCable.server.broadcast(
      "chat_channel_#{sorted_ids[0]}_#{sorted_ids[1]}",
      render_message(message, user)
    )
  end

  private

  def render_message(message, user)
    ApplicationController.renderer.render(partial: 'messages/message', locals: { message: message, current_user: user })
  end
end