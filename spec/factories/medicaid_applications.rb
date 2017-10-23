FactoryGirl.define do
  factory :medicaid_application do
    michigan_resident true

    trait :with_member do
      after :create do |app|
        create(:member, benefit_application: app)
      end
    end
  end
end
