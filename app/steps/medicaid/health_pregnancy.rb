# frozen_string_literal: true

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
      members.sort_by(&:id).first.female?
    end
  end
end
