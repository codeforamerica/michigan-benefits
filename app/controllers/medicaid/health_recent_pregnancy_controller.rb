# frozen_string_literal: true

module Medicaid
  class HealthRecentPregnancyController < Medicaid::ManyMemberStepsController
    private

    def skip?
      no_pregnancies? ||
        only_males? ||
        (single_female_member_is_pregnant? && update_primary_female_member)
    end

    def step_class
      Medicaid::HealthPregnancy
    end

    def member_attrs
      %i[new_mom]
    end

    def no_pregnancies?
      !current_application.anyone_new_mom?
    end

    def only_males?
      current_application.members.select(&:female?).empty?
    end

    def single_female_member_is_pregnant?
      only_one_female? && application_has_a_new_mom?
    end

    def only_one_female?
      current_application.members.select(&:female?).count == 1
    end

    def application_has_a_new_mom?
      current_application.anyone_new_mom?
    end

    def update_primary_female_member
      current_application.primary_member.update(new_mom: true)

      true
    end
  end
end
