# frozen_string_literal: true

module Medicaid
  class StepNavigation
    ALL = {
      "Introduction" => [
        Medicaid::IntroLocationController,
        Medicaid::IntroLocationHelpController,
        Medicaid::IntroNameController,
        Medicaid::IntroHouseholdController,
        Medicaid::IntroCollegeController,
        Medicaid::IntroCollegeMemberController,
        Medicaid::IntroCitizenController,
        # multi-member Medicaid::IntroCaretakerController,
        # multi-member Medicaid::IntroCaretakerMemberController,
      ],
      "Insurance" => [
        Medicaid::InsuranceNeededController,
        Medicaid::InsuranceCurrentController,
        Medicaid::InsuranceCurrentTypeController,
        Medicaid::InsuranceMedicalExpensesController,
      ],
      "Health" => [
        Medicaid::HealthDisabilityController,
        Medicaid::HealthPregnancyController,
        Medicaid::HealthFlintWaterCrisisController,
        Medicaid::HealthFlintWaterCrisisConfirmationController,
      ],
      "Taxes" => [
        Medicaid::TaxFilingController,
      ],
      "Income" => [
        Medicaid::IncomeJobController,
        Medicaid::IncomeJobNumberController,
        Medicaid::IncomeJobNumberContinuedController,
        Medicaid::IncomeJobNumberMemberController,
        Medicaid::IncomeSelfEmploymentController,
        Medicaid::IncomeOtherIncomeController,
        Medicaid::IncomeOtherIncomeTypeController,
      ],
      "Expenses" => [
        Medicaid::ExpensesAlimonyController,
        Medicaid::ExpensesStudentLoanController,
      ],
      "Income & Expense Amounts" => [
        Medicaid::AmountsOverviewController,
        Medicaid::AmountsIncomeController,
        Medicaid::AmountsExpensesController,
      ],
      "Contact" => [
        Medicaid::ContactController,
        Medicaid::ContactHomeAddressController,
        Medicaid::ContactOtherAddressController,
        Medicaid::ContactMailingAddressController,
        Medicaid::ContactHomelessController,
        Medicaid::ContactResidentialNoMailAddressController,
        Medicaid::ContactPhoneController,
        Medicaid::ContactTextMessagesController,
        Medicaid::ContactEmailController,
        Medicaid::ContactSsDobController,
        Medicaid::ContactSocialSecurityController,
      ],
      "Success" => [
        Medicaid::ConfirmationController,
        Medicaid::DocumentsController,
      ],
    }.freeze

    SUBSTEPS = {
      Medicaid::IntroHouseholdMemberController =>
        Medicaid::IntroHouseholdController,
    }.freeze

    class << self
      delegate :first, to: :steps

      def sections
        ALL
      end

      def steps
        @steps ||= ALL.values.flatten.freeze
      end

      def steps_and_substeps
        @steps_and_substeps ||= (steps + SUBSTEPS.keys).uniq.freeze
      end
    end

    delegate :steps, to: :class

    def initialize(step_instance_or_class)
      @step =
        if step_instance_or_class.is_a?(Class)
          step_instance_or_class
        else
          step_instance_or_class.class
        end
    end

    def next
      step_at(1)
    end

    def skip
      step_at(2)
    end

    def previous
      step_at(-1)
    end

    def index
      steps.index(@step)
    end

    def parent
      self.class.new(SUBSTEPS[@step])
    end

    private

    def step_at(increment)
      if index
        new_index = index + increment
        new_index = nil if new_index.negative? || new_index >= steps.length
      else
        new_index = parent.index
      end

      steps.at(new_index) if new_index
    end
  end
end
