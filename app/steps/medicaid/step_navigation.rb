module Medicaid
  class StepNavigation
    ALL = {
      "Introduction" => [
        Medicaid::IntroLocationController,
        Medicaid::IntroLocationHelpController,
        Medicaid::IntroNameController,
        Medicaid::IntroHouseholdController,
        Medicaid::IntroMaritalStatusController,
        Medicaid::IntroMaritalStatusMemberController,
        Medicaid::IntroMaritalStatusIndicateSpouseController,
        Medicaid::IntroCollegeController,
        Medicaid::IntroCollegeMemberController,
        Medicaid::IntroCitizenController,
        Medicaid::IntroCitizenMemberController,
        Medicaid::IntroCaretakerController,
        Medicaid::IntroCaretakerMemberController,
      ],
      "Insurance" => [
        Medicaid::InsuranceNeededController,
        Medicaid::InsuranceCurrentController,
        Medicaid::InsuranceCurrentMemberController,
        Medicaid::InsuranceCurrentTypeController,
        Medicaid::InsuranceMedicalExpensesController,
      ],
      "Health" => [
        Medicaid::HealthDisabilityController,
        Medicaid::HealthDisabilityMemberController,
        Medicaid::HealthPregnancyController,
        Medicaid::HealthPregnancyMemberController,
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
        Medicaid::IncomeSelfEmploymentMemberController,
        Medicaid::IncomeOtherIncomeController,
        Medicaid::IncomeOtherIncomeMemberController,
        Medicaid::IncomeOtherIncomeTypeController,
      ],
      "Expenses" => [
        Medicaid::ExpensesAlimonyController,
        Medicaid::ExpensesAlimonyMemberController,
        Medicaid::ExpensesStudentLoanController,
        Medicaid::ExpensesStudentLoanMemberController,
      ],
      "Income & Expense Amounts" => [
        Medicaid::AmountsOverviewController,
        Medicaid::AmountsIncomeController,
        Medicaid::AmountsExpensesController,
      ],
      "Contact" => [
        Medicaid::ContactIntroductionController,
        Medicaid::ContactController,
        Medicaid::ContactHomeAddressController,
        Medicaid::ContactOtherAddressController,
        Medicaid::ContactMailingAddressController,
        Medicaid::ContactPhoneController,
        Medicaid::ContactTextMessagesController,
        Medicaid::ContactEmailController,
        Medicaid::ContactSsDobController,
        Medicaid::ContactSocialSecurityController,
      ],
      "Paperwork" => [
        Medicaid::PaperworkGuideController,
        Medicaid::PaperworkController,
      ],
      "Legal" => [
        Medicaid::LegalAgreementController,
        Medicaid::SignAndSubmitController,
      ],
      "Success" => [
        Medicaid::SuccessController,
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
