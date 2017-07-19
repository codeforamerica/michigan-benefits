# frozen_string_literal: true

class StepNavigation
  ALL = {
    'Introduction' => [
      IntroductionIntroduceYourselfController,
      IntroductionContactInformationController,
      IntroductionHomeAddressController,
      IntroductionCompleteController
    ],
    'Your Household' => [
      HouseholdIntroductionController,
      HouseholdPersonalDetailsController,
      HouseholdMembersOverviewController,
      HouseholdMoreInfoController,
      HouseholdSituationsController,
      HouseholdHealthController,
      HouseholdHealthSituationsController,
      HouseholdTaxController,
      HouseholdTaxHowController
    ],
    'Money & Income' => [
      IncomeIntroductionController,
      IncomeChangeController,
      IncomeChangeExplanationController,
      IncomeCurrentlyEmployedController,
      IncomePerMemberController,
      IncomeFluctuationController,
      IncomeAdditionalSourcesController,
      IncomeAdditionalController,
      IncomeOtherAssetsController,
      IncomeOtherAssetsContinuedController
    ],
    'Expenses' => [
      ExpensesIntroductionController,
      ExpensesHousingController,
      ExpensesAdditionalSourcesController,
      ExpensesAdditionalController
    ],
    'Preferences' => [
      PreferencesRemindersController,
      PreferencesRemindersConfirmationController,
      PreferencesForInterviewController,
      PreferencesAnythingElse
    ],
    'Legal' => [
      LegalAgreement,
      SignAndSubmit
    ],
    'Submit Documents' => [
      MaybeSubmitDocumentsController
    ]
  }.freeze

  SUBSTEPS = {
    HouseholdAddMemberController => HouseholdMembersOverviewController
  }.freeze

  def self.sections
    ALL
  end

  def self.steps
    ALL.values.flatten
  end

  def self.simple_step_controllers
    steps
      .concat(SUBSTEPS.keys)
      .uniq
      .select { |step_class| refactored?(step_class) }
  end

  def self.refactored?(step_class)
    step_class < SimpleStepController
  end

  def steps
    self.class.steps
  end

  def initialize(step_instance_or_class)
    @step = if step_instance_or_class.is_a?(Class)
              step_instance_or_class
            else
              step_instance_or_class.class
    end
  end

  def next
    if index
      steps.at(index + 1)
    else
      steps.at(parent.index)
    end
  end

  def previous
    if index
      new_index = index - 1
      new_index >= 0 ? steps.at(new_index) : nil
    else
      steps.at(parent.index)
    end
  end

  def progress
    index ? "#{index + 1}/#{steps.size}" : ''
  end

  def index
    steps.index(@step)
  end

  def parent
    self.class.new(SUBSTEPS[@step])
  end
end
