FactoryBot.define do
  factory :mailing_address, class: Address do
    benefit_application { create(:snap_application) }
    mailing true
    street_address "123 Main St."
    city "Flint"
    zip "12345"
    state "MI"
  end

  factory :residential_address, class: Address do
    benefit_application { create(:snap_application) }
    mailing false
    street_address "123 Main St."
    city "Flint"
    zip "12345"
    state "MI"
  end
end
