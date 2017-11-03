module Medicaid
  class IncomeSelfEmploymentMemberController <
      Medicaid::ManyMemberStepsController

    private

    def skip?
      single_member_household? || !current_application.anyone_self_employed?
    end

    def member_attrs
      %i[self_employed]
    end
  end
end
