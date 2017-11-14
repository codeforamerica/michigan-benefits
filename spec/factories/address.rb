FactoryBot.define do
  factory :mailing_address, class: Address do
    mailing true
    street_address "123 Main St."
    city "Flint"
    zip "12345"
    county "Genesee"
    state "MI"
  end

  factory :residential_address, class: Address do
    mailing false
    street_address "123 Main St."
    city "Flint"
    zip "12345"
    county "Genesee"
    state "MI"
  end
end
