require 'openai'

class OpenAiChatService
  def initialize(messages)
    @messages = messages
  end

  def chat
    client = OpenAI::Client.new
    response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: @messages,
        temperature: 0.8,
        max_tokens: 500
      }
    )
    response.dig("choices", 0, "message", "content").strip
  end
end