module Medicaid
  class IncomeJobNumberMemberController < Medicaid::ManyMemberStepsController
    private

    def update_application
      super

      current_application.members.each do |member|
        member.update!(employed: member.employed_number_of_jobs.positive?)
        member.modify_employments
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
