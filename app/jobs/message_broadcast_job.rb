class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    sorted_ids = [message.sender_id, message.receiver_id].sort
    ActionCable.server.broadcast(
      "chat_channel_#{sorted_ids[0]}_#{sorted_ids[1]}",
      message: render_message(message)
    )
  end

  private

  def render_message(message)
    ApplicationController.renderer.render(partial: 'messages/message', locals: { message: message })
  end
end