FactoryBot.define do
  factory :like do
    post
    user
    button_type { 'fight' }
  end
end
