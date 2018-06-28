FactoryBot.define do
  factory :additional_income do
    income_type "unemployment"

    household_member
  end
end
