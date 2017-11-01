# frozen_string_literal: true

module Medicaid
  class AmountsExpensesController < MedicaidStepsController
    private

    def step_class
      Medicaid::AmountsExpenses
    end

    def skip?
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
