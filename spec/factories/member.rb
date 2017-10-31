FactoryBot.define do
  factory :member do
    first_name "Lilly"
    last_name "Pad"
    sex "female"
    marital_status "Widowed"
    birthday { DateTime.parse("August 18, 1990") }
    benefit_application { create(:snap_application) }

    trait :female do
      sex "female"
    end

    trait :male do
      sex "male"
    end
  end
end
