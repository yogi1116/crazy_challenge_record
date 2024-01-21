FactoryBot.define do
  factory :post do
    title { 'title' }
    content { 'content' }
    impression_event { 'impression_event' }
    lesson { 'lesson' }

    after(:build) do |post|
      post.categories << Category.find_or_create_by(name: '冒険・探究')
      post.images.attach(
        io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'crazy_1.png')),
        filename: 'complete.png',
        content_type: 'image/png'
      )
    end

    trait :complete do
      challenge_result { 'complete' }
      record { 'record' }
    end

    trait :give_up do
      challenge_result { 'give_up' }
      retry_value { 'try' }
    end
  end
end
