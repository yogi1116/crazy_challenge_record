require 'openai'

class OpenAiChatService
  def initialize(messages)
    @messages = messages
  end

  def chat
    client = OpenAI::Client.new(api_key: ENV['OPENAI_SECRET_KEY'])
    response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: @messages,
        temperature: 0.7
      }
    )
    response.dig("choices", 0, "message", "content").strip
  end
end