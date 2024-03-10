FactoryBot.define do
  factory :challenge_post do
    title { 'title' }
    content { 'content' }

    after(:build) do |challenge_post|
      challenge_post.categories << Category.find_or_create_by(name: '冒険・探究')
    end
  end
end