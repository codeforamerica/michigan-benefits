FactoryBot.define do
  factory :medicaid_application do
    michigan_resident true

    trait :signed do
      signed_at Time.now
    end

    trait :unsigned do
      signed_at nil
    end

    trait :with_member do
      after :create do |app|
        create(:member, benefit_application: app)
      end
    end

    trait :multimember do
      after :create do |app|
        create_list(:member, 2, benefit_application: app)
      end
    end
  end
end
