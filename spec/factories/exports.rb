FactoryGirl.define do
  factory :export do
    snap_application

    destination :email

    trait :faxed do
      destination :fax
    end

    trait :emailed do
      destination :email
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
