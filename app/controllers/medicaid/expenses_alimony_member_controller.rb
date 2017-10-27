# frozen_string_literal: true

module Medicaid
  class ExpensesAlimonyMemberController < Medicaid::ManyMemberStepsController
    private

    def skip?
      nobody_pays_child_support_alimony_arrears? || single_member_household?
    end

    def member_attrs
      %i[pay_child_support_alimony_arrears]
    end

    def nobody_pays_child_support_alimony_arrears?
      !current_application.anyone_pay_child_support_alimony_arrears?
    end
  end
end
