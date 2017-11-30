FactoryBot.define do
  factory :export do
    benefit_application { create(:snap_application) }

    destination :client_email

    trait :faxed do
      destination :fax
    end

    trait :emailed_client do
      destination :client_email
    end

    trait :emailed_office do
      destination :office_email
    end

    trait :succeeded do
      status :succeeded
      completed_at Time.zone.now
    end

    trait :failed do
      status :failed
    end
  end
end
