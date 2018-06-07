FactoryBot.define do
  factory :common_application do
    association :navigator, factory: :application_navigator

    trait :single_member do
      after(:create)  { |app| create(:household_member, common_application: app) }
    end

    trait :single_member_food do
      after(:create)  { |app| create(:household_member, common_application: app, requesting_food: "yes") }
    end

    trait :single_member_healthcare do
      after(:create)  { |app| create(:household_member, common_application: app, requesting_healthcare: "yes") }
    end

    trait :multi_member do
      after(:create)  { |app| create_list(:household_member, 3, common_application: app) }
    end

    trait :multi_member_food do
      after(:create)  { |app| create_list(:household_member, 3, common_application: app, requesting_food: "yes") }
    end

    trait :multi_member_healthcare do
      after(:create)  { |app| create_list(:household_member, 3, common_application: app, requesting_healthcare: "yes") }
    end
  end
end
