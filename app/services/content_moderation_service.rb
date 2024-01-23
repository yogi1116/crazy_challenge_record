
require 'googleauth'

class ContentModerationService
  SCOPE = 'https://www.googleapis.com/auth/cloud-language'

  def initialize(post)
    @post = post
    @credentials = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: File.open('app/services/service_account.json'),
      scope: SCOPE
    )
  end

  def analyze
    access_token = @credentials.fetch_access_token!['access_token']
    url = 'https://language.googleapis.com/v1/documents:moderateText'
    response = Faraday.post(url) do |req|
      req.headers['Authorization'] = "Bearer #{access_token}"
      req.headers['Content-Type'] = 'application/json; charset=utf-8'
      req.body = {
        document: {
          type: 'PLAIN_TEXT',
          content: @post
        }
      }.to_json
    end

    if response.success?
      JSON.parse(response.body)
    else
      # ステータスコードによっては再試行するなどの処理を入れる
      raise "API request failed with status: #{response.status}"
    end
  rescue Faraday::Error => e
    raise "HTTP request failed: #{e.message}"
  rescue JSON::ParserError => e
    raise "JSON parsing failed: #{e.message}"
  end
end