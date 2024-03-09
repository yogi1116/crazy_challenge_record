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
    receiver_id = @message.receiver_id
    sender_id = current_user.id
    private_chat_room = Message.private_chat_room_name(sender_id, receiver_id)
    @sender = @message.sender
    if @message.save
      ActionCable.server.broadcast private_chat_room, {
        message_body: @message.body,
        message_image_url: @message.image.file.present? ? @message.image.url : '',
        message_sent_at: @message.sent_at.strftime('%H:%M'),
        sender_id: sender_id,
        receiver_id: receiver_id,
        message_id: @message.id,
        current_user_id: current_user.id,
        sender_avatar_url: @sender.profile.avatar.url
      }
    else
      ActionCable.server.broadcast private_chat_room, { error: render_errors(@message) }
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

  def render_errors(message)
    ApplicationController.renderer.render(partial: 'shared/error_messages', locals: { object: message, text_color: 'text-white' }, formats: [:html])
  end
end
