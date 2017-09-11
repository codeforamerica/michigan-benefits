FactoryGirl.define do
  factory :export do
    destination :email
    snap_application

    trait :faxed do
      destination :fax
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
