module Medicaid
  class IncomeJobNumberMemberController < Medicaid::ManyMemberStepsController
    private

    def after_successful_update_hook
      current_application.members.each do |member|
        member.update(employed: member.employed_number_of_jobs&.positive?)
      end
    end

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
