if Rails.env.test?
  $redis = Redis.new(url: 'redis://localhost:6379/0') # テスト環境用
else
  $redis = Redis.new(url: ENV['REDIS_URL'] || 'redis://localhost:6379/1') # 本番や開発環境用
end
