FactoryBot.define do
  factory :member do
    first_name "Lilly"
    last_name "Pad"
    sex "female"
    marital_status "Widowed"
    ssn "123 12 1234"
    birthday { DateTime.parse("August 18, 1990") }
    benefit_application { create(:snap_application) }
  end
end
