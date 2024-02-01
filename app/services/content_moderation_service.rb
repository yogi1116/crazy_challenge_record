require 'googleauth'

class ContentModerationService
  SCOPE = 'https://www.googleapis.com/auth/cloud-language'.freeze

  def initialize(post)
    @post = post
    @credentials = set_credentials
  end

  def analyze
    access_token = @credentials.fetch_access_token!['access_token']
    response = post_request(access_token)

    raise "API request failed with status: #{response.status}" unless response.success?

    parse_response(response)
  rescue Faraday::Error => e
    raise "HTTP request failed: #{e.message}"
  rescue JSON::ParserError => e
    raise "JSON parsing failed: #{e.message}"
  end

  private

  def set_credentials
    Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: StringIO.new(Rails.application.credentials.google[:natural_language_credentials]),
      scope: SCOPE
    )
  end

  def post_request(access_token)
    url = 'https://language.googleapis.com/v1/documents:moderateText'
    Faraday.post(url) do |req|
      req.headers['Authorization'] = "Bearer #{access_token}"
      req.headers['Content-Type'] = 'application/json; charset=utf-8'
      req.body = request_body
    end
  end

  def request_body
    {
      document: {
        type: 'PLAIN_TEXT',
        content: @post
      }
    }.to_json
  end

  def parse_response(response)
    JSON.parse(response.body)
  end
end
