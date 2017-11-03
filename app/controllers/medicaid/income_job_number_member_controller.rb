module Medicaid
  class IncomeJobNumberMemberController < Medicaid::ManyMemberStepsController
    private

    def skip?
      nobody_employed? || single_member_household?
    end

    def nobody_employed?
      !current_application.anyone_employed?
    end

    def member_attrs
      %i[employed_number_of_jobs]
    end
  end
end
