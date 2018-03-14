FactoryBot.define do
  factory :household_member do
    first_name "Lilly"
    last_name "Pad"

    trait :in_snap_household do
      buy_and_prepare_food_together "yes"
      requesting_food "yes"
    end
  end
end
