class MessagesController < ApplicationController
  def index

  end

  def create
    @message = current_user.sent_messages.build(message_params)
    if @message.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to messages_path }
      end
    else
      prepare_messages
      respond_with_error
    end
  end

  def show
    receiver_id = User.find_id_by_uuid(params[:id])
    @receiver = User.find(receiver_id)
    @messages = Message.where("(user_id = ? AND receiver_id = ?) OR (user_id = ? AND receiver_id = ?)",
                              current_user.id, receiver_id, receiver_id, current_user.id)
    @message = Message.new
    @message.receiver_id = @receiver.id
  end

  def destory

  end

  private

  def message_params
    params.require(:message).permit(:body, :receiver_id)
  end

  def prepare_messages
    @messages = current_user.sent_messages
  end

  def respond_with_error
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("message_form", partial: "form", locals: { message: @message }) }
      format.html { render :new }
    end
  end
end
