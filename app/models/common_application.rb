class CommonApplication < ApplicationRecord
  include CommonBenefitApplication

  has_many :members, class_name: "HouseholdMember", foreign_key: "common_application_id"
end
