FactoryBot.define do
  factory :post do
    title { 'title' }
    content { 'content' }
    impression_event { 'impression_event' }
    lesson { 'lesson' }

    trait :complete do
      challenge_result { 'complete' }
      record { 'record' }
    end

    trait :give_up do
      challenge_result { 'give_up' }
      retry_value { 'try' }
    end

    trait :with_categories do
      after(:build) do |post|
        categories = create_list(:category, 3, name: '冒険・探究')
        post.categories << categories
      end
    end

    trait :with_images do
      after(:build) do |post|
        4.times do |n|
          post.images.attach(io: File.open(Rails.root.join("spec/fixtures/files/sample_image_#{n}.jpg")), filename: "sample_image_#{n}.jpg", content_type: 'image/jpg')
        end
      end
    end
  end
end
