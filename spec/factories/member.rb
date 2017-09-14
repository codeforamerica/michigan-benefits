FactoryGirl.define do
  factory :member do
    first_name "Lilly"
    last_name "Pad"
    sex "female"
    marital_status "Widowed"
    ssn "123121234"
    birthday { DateTime.parse("August 18, 1990") }
  end
end
