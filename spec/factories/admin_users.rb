FactoryBot.define do
  factory :admin_user do
    email { "test@example.com" }
    password { "123456" }
  end
end
