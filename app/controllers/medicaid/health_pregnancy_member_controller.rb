module Medicaid
  class HealthPregnancyMemberController < Medicaid::ManyMemberStepsController
    private

    def members
      current_application.members.select(&:female?)
    end

    def skip?
      no_pregnancies? || only_males? || single_female_member_is_pregnant?
    end

    def member_attrs
      %i[new_mom]
    end

    def no_pregnancies?
      !current_application.anyone_new_mom?
    end

    def only_males?
      members.empty?
    end

    def single_female_member_is_pregnant?
      only_one_female? && application_has_a_new_mom?
    end

    def only_one_female?
      members.count == 1
    end

    def application_has_a_new_mom?
      current_application.anyone_new_mom?
    end
  end
end
