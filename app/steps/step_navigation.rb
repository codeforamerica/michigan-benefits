# frozen_string_literal: true

class StepNavigation
  ALL = {
    "Introduction" => [
      IntroduceYourselfController,
      ContactInformationController,
      MailingAddressController,
      ResidentialAddressController,
      IntroductionCompleteController,
    ],
    "Your Household" => [
      HouseholdIntroductionController,
      PersonalDetailController,
      HouseholdMembersOverviewController,
      HouseholdMoreInfoController,
      HouseholdMoreInfoPerMemberController,
    ],
    "Money & Income" => [
      IncomeIntroductionController,
      IncomeChangeController,
      IncomeChangeExplanationController,
      IncomeEmploymentStatusController,
      IncomeDetailsPerMemberController,
      IncomeAdditionalSourcesController,
      IncomeAdditionalController,
      IncomeOtherAssetsController,
      IncomeOtherAssetsContinuedController,
    ],
    "Expenses" => [
      ExpensesIntroductionController,
      ExpensesHousingController,
      ExpensesAdditionalSourcesController,
      ExpensesAdditionalController,
    ],
    "General" => [
      GeneralInterviewPreferenceController,
      GeneralAnythingElseController,
    ],
    "Legal" => [
      LegalAgreementController,
      SignAndSubmitController,
    ],
    "Submit Documents" => [
      DocumentGuideController,
      DocumentsController,
      SuccessController,
    ],
  }.freeze

  SUBSTEPS = {
    HouseholdAddMemberController => HouseholdMembersOverviewController,
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
