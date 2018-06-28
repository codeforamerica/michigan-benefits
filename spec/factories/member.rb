FactoryBot.define do
  factory :member do
    first_name "Lilly"
    last_name "Pad"
    sex "female"
    birthday { DateTime.parse("August 18, 1990") }

    association :benefit_application, factory: :snap_application

    trait :female do
      sex "female"
    end

    trait :male do
      sex "male"
    end

    trait :insured do
      insured true
      requesting_health_insurance true
    end

    trait :not_insured do
      insured false
      requesting_health_insurance false
    end
  end
end
