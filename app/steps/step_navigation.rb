class StepNavigation
  ALL = {
    "Introduction" => [
      IntroductionIntroduceYourself,
      IntroductionContactInformation,
      IntroductionHomeAddress,
      IntroductionComplete,
    ],
    "Your Household" => [
      HouseholdIntroduction,
      HouseholdPersonalDetails,
      HouseholdMembers,
      HouseholdMoreInfo,
      HouseholdSituations,
      HouseholdHealth,
      HouseholdHealthSituations,
      HouseholdTax,
      HouseholdTaxHow,
    ],
    "Money & Income" => [
      IncomeIntroduction,
      IncomeChange,
      IncomeChangeExplanation,
      IncomeCurrentlyEmployed,
      IncomePerMember,
      IncomeFluctuation,
      IncomeAdditionalSources,
      IncomeAdditional,
      IncomeOtherAssets,
      IncomeOtherAssetsContinued,
    ],
    "Expenses" => [
      ExpensesIntroduction,
      ExpensesHousing,
      ExpensesAdditionalSources,
      ExpensesAdditional
    ],
    "Preferences" => [
      PreferencesReminders,
      PreferencesForInterview
    ],
    "Legal" => [
      LegalAgreement,
      SignAndSubmit,
    ],
    "Submit Documents" => [
      MaybeSubmitDocuments
    ]
  }

  SUBSTEPS = {
    HouseholdAddMember => HouseholdMembers,
  }

  def self.sections
    ALL
  end

  def self.steps
    ALL.values.flatten
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
      (new_index >= 0) ? steps.at(new_index) : nil
    else
      steps.at(parent.index)
    end
  end

  def progress
    index ? "#{index + 1}/#{steps.size}" : ""
  end

  def index
    steps.index(@step)
  end

  def parent
    self.class.new(SUBSTEPS[@step])
  end
end
