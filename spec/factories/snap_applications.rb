FactoryBot.define do
  factory :snap_application do
    email "test@example.com"
    signature "Mr. RJD2"
    signed_at Date.current
    mailing_address_same_as_residential_address false

    trait :with_member do
      after :create do |app|
        create(:member, benefit_application: app)
      end
    end

    trait :faxed do
      after :create do |app|
        create(:export, :faxed, :succeeded, benefit_application: app)
      end
    end

    trait :emailed_client do
      after :create do |app|
        create(:export, :emailed_client, :succeeded, benefit_application: app)
      end
    end

    trait :emailed_office do
      after :create do |app|
        create(:export, :emailed_office, :succeeded, benefit_application: app)
      end
    end
  end
end
