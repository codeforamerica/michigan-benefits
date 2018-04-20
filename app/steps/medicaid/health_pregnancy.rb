module Medicaid
  class HealthPregnancy < Step
    step_attributes(
      :anyone_new_mom,
      :members,
    )

    def female_members
      members.select(&:female?)
    end

    def single_female_start_of_question
      if primary_member_is_female?
        "Have you"
      else
        "Has #{female_members.first.first_name}"
      end
    end

    def primary_member_is_female?
      members.min_by(&:id).female?
    end
  end
end
