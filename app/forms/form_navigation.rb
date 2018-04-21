class FormNavigation
  MAIN = {
    "Welcome" => [
      Integrated::ResideInStateController,
      Integrated::ResideOutOfStateController,
      Integrated::IntroduceYourselfController,
      Integrated::LivingSituationController,
    ],
    "Household" => [
      Integrated::HouseholdMembersOverviewController,
    ],
    "Food Assistance" => [
      Integrated::FoodAssistanceController,
      Integrated::BuyAndPrepareFoodWithOtherPersonController,
      Integrated::ShareFoodCostsWithHouseholdController,
      Integrated::BuyAndPrepareFoodSeparatelyController,
    ],
    "Healthcare" => [
      Integrated::ReviewFoodAssistanceMembersController,
      Integrated::HealthcareController,
      Integrated::DeclineHealthcareController,
    ],
    "Taxes" => [
      Integrated::FileTaxesNextYearController,
      Integrated::IncludeAnyoneElseOnTaxesController,
      Integrated::DescribeTaxRelationshipsController,
      Integrated::ReviewTaxRelationshipsController,
    ],
    "Married" => [
      Integrated::AreYouMarriedController,
      Integrated::AnyoneMarriedController,
      Integrated::WhoIsMarriedController,
    ],
    "Caretaker" => [
      Integrated::AnyoneCaretakerController,
      Integrated::WhoIsCaretakerController,
    ],
    "Student" => [
      Integrated::AreYouStudentController,
      Integrated::AnyoneStudentController,
      Integrated::WhoIsStudentController,
    ],
    "Disabled" => [
      Integrated::AreYouDisabledController,
      Integrated::AnyoneDisabledController,
      Integrated::WhoIsDisabledController,
    ],
    "Veteran" => [
      Integrated::AreYouVeteranController,
      Integrated::AnyoneVeteranController,
      Integrated::WhoIsVeteranController,
    ],
    "Foster" => [
      Integrated::WereYouFosterCareController,
      Integrated::AnyoneFosterCareController,
      Integrated::WhoWasFosterCareController,
    ],
    "Citizen" => [
      Integrated::AreYouCitizenController,
      Integrated::EveryoneCitizenController,
      Integrated::WhoIsNotCitizenController,
      Integrated::ImmigrationInfoController,
    ],
    "Household Expenses" => [
      Integrated::HousingExpensesController,
      Integrated::UtilityExpensesController,
      Integrated::DependentCareExpensesController,
      Integrated::ChildcareExpensesController,
      Integrated::ChildSupportController,
    ],
    "Medical Bills and Health Insurance" => [
      Integrated::AreYouHealthcareEnrolledController,
      Integrated::AnyoneHealthcareEnrolledController,
      Integrated::WhoIsHealthcareEnrolledController,
      Integrated::OngoingMedicalExpensesController,
      Integrated::DoYouHaveMedicalBillsController,
      Integrated::AnyoneHaveMedicalBillsController,
      Integrated::WhoHasMedicalBillsController,
    ],
    "Pregnancy" => [
      Integrated::AreYouPregnantController,
      Integrated::AnyonePregnantController,
      Integrated::WhoIsPregnantController,
      Integrated::HowManyBabiesController,
      Integrated::DoYouHavePregnancyExpensesController,
      Integrated::AnyoneHavePregnancyExpensesController,
      Integrated::WhoHasPregnancyExpensesController,
    ],
    "Flint Water Crisis" => [
      Integrated::AreYouFlintWaterController,
      Integrated::AnyoneFlintWaterController,
      Integrated::WhoIsFlintWaterController,
    ],
    "Income and Employment" => [
      Integrated::HasYourIncomeChangedController,
      Integrated::TellUsIncomeChangedController,
      Integrated::DoYouHaveJobController,
      Integrated::HowManyJobsController,
      Integrated::AreYouSelfEmployedController,
      Integrated::AnyoneSelfEmployedController,
      Integrated::WhoIsSelfEmployedController,
      Integrated::IncomeSourcesController,
    ],
    "Assets" => [],
    "Specifics" => [],
    "Finishing Up" => [
      Integrated::AuthorizedRepController,
      Integrated::TellUsAuthorizedRepController,
      Integrated::ApplicationSubmittedController,
    ],
  }.freeze

  OFF_MAIN = [
    Integrated::AddHouseholdMemberController,
    Integrated::RemoveHouseholdMemberController,
    Integrated::AddFoodMemberController,
    Integrated::RemoveFoodMemberController,
    Integrated::AddHealthcareMemberController,
    Integrated::AddTaxMemberController,
    Integrated::RemoveTaxMemberController,
  ].freeze

  class << self
    delegate :first, to: :form_controllers

    def form_controllers_with_groupings
      MAIN
    end

    def form_controllers
      MAIN.values.flatten.freeze
    end

    def all
      (MAIN.values + OFF_MAIN).flatten.freeze
    end
  end

  delegate :form_controllers, to: :class

  def initialize(form_controller)
    @form_controller = form_controller
  end

  def next
    return unless index
    form_controllers_until_end = form_controllers[index + 1..-1]
    seek(form_controllers_until_end)
  end

  def previous
    return unless index
    return if index.zero?
    form_controllers_to_beginning = form_controllers[0..index - 1].reverse
    seek(form_controllers_to_beginning)
  end

  def index
    form_controllers.index(@form_controller.class)
  end

  private

  def seek(list)
    list.detect do |form_controller_class|
      !form_controller_class.skip?(@form_controller.current_application)
    end
  end
end
