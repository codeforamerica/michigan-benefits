FactoryGirl.define do
  factory :snap_application do
    email "test@example.com"
    birthday 50.years.ago
    signature "Mr. RJD2"
    signed_at Date.current
    mailing_address_same_as_residential_address false
  end
end
