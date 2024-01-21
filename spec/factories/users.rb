FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email}
    password { 'Password01' }
    password_confirmation { 'Password01' }
    username { 'original' }
  end
end
