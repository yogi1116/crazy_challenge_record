CarrierWave.configure do |config|
  config.storage    = :aws
  config.aws_bucket = ENV['AWS_BUCKET']
  config.aws_acl    = 'private'

  config.aws_authenticated_url_expiration = 60 * 60 * 24 * 7

  config.aws_credentials = {
    access_key_id:     ENV['AWS_ACCESS_KEY'],
    secret_access_key: ENV['AWS_SECRET_KEY'],
    region:            ENV['AWS_REGION'],
  }
end