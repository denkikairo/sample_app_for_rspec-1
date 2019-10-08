FactoryBot.define do
  factory :user do
    email { "example@gmail.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end
