# frozen_string_literal: true

module Medicaid
  class IncomeJobNumberMemberController < Medicaid::ManyMemberStepsController
    private

    def skip?
      not_employed? || single_member_household?
    end

    def not_employed?
      !current_application.employed?
    end

    def member_attrs
      %i[employed_number_of_jobs]
    end
  end
end
