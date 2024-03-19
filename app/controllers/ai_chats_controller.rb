class AiChatsController < ApplicationController
  before_action :set_chat_limit_reached, only: [:new, :create]

  def new
    @chat_bodies = fetch_chat_bodies
  end

  def create
    if @chat_limit_reached
      @chat_bodies = fetch_chat_bodies
      flash.now[:error] = '本日のチャット回数の上限に達しました。'
      render :new, status: :unprocessable_entity
    else
      service = OpenAiChatService.new([{role: "user", content: params[:body]}])
      @ai_response = service.chat

      save_chat_body(params[:body], @ai_response)
      respond_to do |format|
        format.turbo_stream
      end
    end
  end

  private

  def set_chat_limit_reached
    # ログインしているユーザーIDを基にしたカウントキーを使用
    count_key = "chat_count:user:#{session[:user_id]}"
    chat_count = $redis.get(count_key).to_i
    @chat_limit_reached = chat_count >= 3
    unless @chat_limit_reached
      $redis.incr(count_key)
      $redis.expire(count_key, seconds_until_end_of_day_jst)
    end
  end

  def fetch_chat_bodies
    # ログインしているユーザーIDを基にしたチャットキーを使用
    chat_key = "chat:user:#{session[:user_id]}"
    $redis.lrange(chat_key, 0, -1).map { |body| JSON.parse(body) }
  end

  def save_chat_body(user_input, ai_response)
    chat_key = "chat:user:#{session[:user_id]}"
    $redis.rpush(chat_key, {user: user_input, ai: ai_response}.to_json)
    $redis.expire(chat_key, seconds_until_end_of_day_jst)
  end

  def seconds_until_end_of_day_jst
    now = Time.current.in_time_zone('Asia/Tokyo')
    end_of_day = now.end_of_day
    (end_of_day - now).to_i
  end
end
