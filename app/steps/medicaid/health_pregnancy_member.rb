module Medicaid
  class HealthPregnancyMember < Step
    step_attributes(:members)

    def female_members
      members.select(&:female?)
    end
  end
end
