FactoryBot.define do
  factory :household_member do
    first_name "Lilly"
    last_name "Pad"

    trait :requesting_food do
      requesting_food "yes"
    end

    trait :requesting_healthcare do
      requesting_healthcare "yes"
    end

    trait :in_food_household do
      buy_and_prepare_food_together "yes"
      requesting_food
    end
  end
end
