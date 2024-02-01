FactoryBot.define do
  factory :comment do
    post
    user
    body { 'new_comment' }
  end
end
