FactoryBot.define do
  factory :address do
    street_address "123 Main St."
    city "Flint"
    zip "12345"
    county "Genesee"
    state "MI"
    mailing false

    factory :mailing_address do
      mailing true
    end
  end
end
