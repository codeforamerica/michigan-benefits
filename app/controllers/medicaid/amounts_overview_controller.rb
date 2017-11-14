module Medicaid
  class AmountsOverviewController < MedicaidStepsController
    private

    def skip?
      no_income? && no_expenses?
    end

    def no_income?
      current_application.no_one_with_income?
    end

    def no_expenses?
      no_self_employment? &&
        no_child_support_alimony_arrears? &&
        no_student_loan_interest?
    end

    def no_self_employment?
      !current_application&.anyone_self_employed?
    end

    def no_child_support_alimony_arrears?
      !current_application&.anyone_pay_child_support_alimony_arrears?
    end

    def no_student_loan_interest?
      !current_application&.anyone_pay_student_loan_interest?
    end
  end
end
