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

    
  end
end
