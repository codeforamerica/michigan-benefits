class FormNavigation
  MAIN = {
    "Welcome" => [
      Integrated::WhichProgramsController,
      Integrated::WelcomeController,
      Integrated::ResideInStateController,
      Integrated::ResideOutOfStateController,
      Integrated::OfficeLocationController,
      Integrated::IntroduceYourselfController,
      Integrated::LivingSituationController,
      Integrated::ResidentialAddressController,
      Integrated::MailingAddressController,
      Integrated::PhoneNumberController,
    ],
    "Household" => [
      Integrated::YourHouseholdController,
      Integrated::HouseholdMembersOverviewController,
    ],
    "Food Assistance" => [
      Integrated::FoodAssistanceController,
      Integrated::BuyAndPrepareFoodWithOtherPersonController,
      Integrated::ShareFoodCostsWithHouseholdController,
      Integrated::BuyAndPrepareFoodSeparatelyController,
      Integrated::ReviewFoodAssistanceMembersController,
    ],
    "Taxes" => [
      Integrated::FileTaxesThisYearController,
      Integrated::ReviewHealthcareHouseholdController,
      Integrated::DescribeTaxRelationshipsController,
    ],
    "Healthcare" => [
      Integrated::HealthcareController,
      Integrated::DeclineHealthcareController,
    ],
    "Household Details" => [
      Integrated::GettingToKnowYouController,
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
      Integrated::HouseholdBillsController,
      Integrated::HousingExpensesController,
      Integrated::RentDetailsController,
      Integrated::MortgageDetailsController,
      Integrated::MobileHomeLotRentDetailsController,
      Integrated::PropertyTaxDetailsController,
      Integrated::HomeownersInsuranceDetailsController,
      Integrated::LandContractDetailsController,
      Integrated::YourHousingExpensesDetailsController,
      Integrated::UtilityExpensesController,
      Integrated::ChildcareExpensesController,
      Integrated::ChildcareExpensesDetailsController,
      Integrated::DependentCareExpensesController,
      Integrated::DependentCareExpensesDetailsController,
      Integrated::ChildSupportController,
      Integrated::ChildSupportDetailsController,
      Integrated::AlimonyController,
      Integrated::AlimonyDetailsController,
      Integrated::StudentLoanInterestController,
      Integrated::StudentLoanInterestDetailsController,
      Integrated::YourExpensesDetailsController,
    ],
    "Medical Bills and Health Insurance" => [
      Integrated::HealthAndInsuranceController,
      Integrated::AreYouHealthcareEnrolledController,
      Integrated::AnyoneHealthcareEnrolledController,
      Integrated::WhoIsHealthcareEnrolledController,
      Integrated::OngoingMedicalExpensesController,
      Integrated::HealthInsuranceExpensesDetailsController,
      Integrated::CopaysExpensesDetailsController,
      Integrated::PrescriptionsExpensesDetailsController,
      Integrated::TransportationExpensesDetailsController,
      Integrated::DentalExpensesDetailsController,
      Integrated::InHomeCareExpensesDetailsController,
      Integrated::HospitalBillsExpensesDetailsController,
      Integrated::OtherMedicalExpensesDetailsController,
      Integrated::OngoingMedicalExpensesDetailsController,
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
      Integrated::IncomeAndEmploymentController,
      Integrated::HasYourIncomeChangedController,
      Integrated::TellUsIncomeChangedController,
      Integrated::DoYouHaveJobController,
      Integrated::HowManyJobsController,
      Integrated::JobDetailsController,
      Integrated::AreYouSelfEmployedController,
      Integrated::AnyoneSelfEmployedController,
      Integrated::WhoIsSelfEmployedController,
      Integrated::SelfEmploymentDetailsController,
      Integrated::IncomeSourcesController,
      Integrated::IncomeSourcesDetailsController,
    ],
    "Savings and Assets" => [
      Integrated::SavingsAndAssetsController,
      Integrated::MoneyInAccountsController,
      Integrated::AmountInAccountsController,
      Integrated::AccountsOverviewController,
      Integrated::VehiclesController,
      Integrated::VehiclesOverviewController,
      Integrated::PropertyController,
    ],
    "Finishing Up" => [
      Integrated::FinishingUpController,
      Integrated::AnythingElseController,
      Integrated::AuthorizedRepController,
      Integrated::TellUsAuthorizedRepController,
      Integrated::ProvideSsnController,
      Integrated::HowElseContactController,
      Integrated::TellUsContactController,
      Integrated::ReviewPaperworkController,
      Integrated::UploadPaperworkController,
      Integrated::LegalAgreementController,
      Integrated::SignSubmitController,
      Integrated::ApplicationSubmittedController,
    ],
  }.freeze

  OFF_MAIN = [
    Integrated::AddHouseholdMemberController,
    Integrated::RemoveHouseholdMemberController,
    Integrated::AddFoodMemberController,
    Integrated::RemoveFoodMemberController,
    Integrated::AddHealthcareMemberController,
    Integrated::RemoveHealthcareMemberController,
    Integrated::AddVehicleController,
    Integrated::RemoveVehicleController,
    Integrated::AddAccountController,
    Integrated::RemoveAccountController,
  ].freeze

  class << self
    delegate :first, to: :form_controllers

    def screens_index
      MAIN
    end

    def form_controllers
      main_controllers = MAIN.values.flatten

      if GateKeeper.demo_environment?
        ([Integrated::DemoSiteWarningController] + main_controllers).freeze
      else
        main_controllers.freeze
      end
    end

    def all
      (MAIN.values + OFF_MAIN + [Integrated::DemoSiteWarningController]).flatten.freeze
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
