class HouseholdMember < ApplicationRecord
  belongs_to :common_application

  enum sex: { unfilled: 0, male: 1, female: 2 }, _prefix: :sex
end
