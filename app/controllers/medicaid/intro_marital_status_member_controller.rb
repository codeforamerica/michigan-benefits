module Medicaid
  class IntroMaritalStatusMemberController < Medicaid::ManyMemberStepsController
    private

    def skip?
      single_member_household? || nobody_married?
    end

    def nobody_married?
      !current_application.anyone_married?
    end

    def member_attrs
      [:married]
    end
  end
end
