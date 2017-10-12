# frozen_string_literal: true

module Medicaid
  class AmountsExpensesController < StandardStepsController
    include MedicaidFlow

    private

    def step_class
      Medicaid::AmountsExpenses
    end

    def skip?
      no_child_support_alimony_arrears? &&
        no_student_loan_interest?
    end

    def no_child_support_alimony_arrears?
      !current_application&.pay_child_support_alimony_arrears?
    end

    def no_student_loan_interest?
      !current_application&.pay_student_loan_interest?
    end
  end
end
