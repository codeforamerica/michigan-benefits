require "capybara/rails"
require "capybara/drivers/chrome"
require "capybara/drivers/headless_chrome"

module MiBridges
  class Driver
    include Capybara::DSL

    delegate :latest_drive_attempt, to: :snap_application

    SIGN_UP_FLOW = [
      HomePage,
      CreateAccountPage,
      CreateAccountConfirmationPage,
      LogInPage,
      PrivacyPinPage,
      BenefitsOverviewPage,
      FraudPenaltyAffidavitPage,
    ].freeze

    SIGN_IN_FLOW = [
      HomeLogInPage,
      MultiFactorAuthPage,
      SecurityQuestionsPage,
      PrivacyPinPage,
      ContinueApplicationPage,
      GoBackToApplicationPage,
    ].freeze

    APPLY_FLOW = [
      SummaryPage,
      AbsentParentDetailsPage,
      AbsentParentInformationPage,
      AdditionalInformationPage,
      BenefitsOverviewPage,
      BenefitsSelectorPage,
      ConceptionPage,
      DependentCarePage,
      DisabilityOrBlindnessReviewPage,
      FinishPage,
      HealthHospitalizationInsurancePremiumsPage,
      HouseholdMemberQuestionsPage,
      HousingBillsPage,
      HousingUtilityBillsPage,
      ImportantInformationPage,
      InformationAboutTheChildPage,
      InpatientHospitalizationNursingCarePage,
      JobIncomeInformationPage,
      LiquidAssetsPage,
      MailingAddressPage,
      MedicalBillsPage,
      MedicalDentalVisionServicesPage,
      MoneyOtherSourcesPage,
      MoreAboutCashOnHandPage,
      MoreAboutCheckingAccountPage,
      MoreAboutChildSupportPaymentPage,
      MoreAboutDisabilityBenefitsPage,
      MoreAboutDisabilityOrBlindnessPage,
      MoreAboutJobIncomePage,
      MoreAboutOtherIncomePage,
      MoreAboutPensionOrRetirementPage,
      MoreAboutRealPropertyPage,
      MoreAboutSavingsAccountPage,
      MoreAboutSelfEmploymentPage,
      MoreAboutSupplementalSecurityIncomePage,
      MoreAboutUnemploymentBenefitsPage,
      MoreAboutWorkersCompensationPage,
      MoreAboutYourPregnancyPage,
      OtherAssetsPage,
      OtherInformationPage,
      OtherTypesOfIncomePage,
      PeopleListedPage,
      PersonalCareServicesProvidedInHomePage,
      PersonalInformationPage,
      PregnancyInformationPage,
      PrescriptionDrugsAndMedicationPage,
      ProgramBenefitsPage,
      RealPropertiesPage,
      RelationshipInformationPage,
      RentOrLotRentPage,
      SchoolEnrollmentPage,
      StartPage,
      BeforeSubmitPage,
      UtilityBillsPage,
      VehiclesPage,
      VeteranInformationPage,
      ViewTrackAndPrintYourApplicationPage,
      YourOtherBillsExpensesPage,
    ].freeze

    def initialize(snap_application:, logger: nil)
      @snap_application = snap_application
      self.logger = logger
    end

    def run
      setup
      sign_up_for_account
      complete_application
      teardown
    end

    def re_run
      setup
      sign_in
      complete_application
      teardown
    end

    private

    def sign_up_for_account
      run_flow(SIGN_UP_FLOW)
    end

    def sign_in
      run_flow(SIGN_IN_FLOW)
    end

    def complete_application
      while page_title != ImportantInformationPage.title
        klass = find_page_klass
        run_flow([klass])
      end

      run_flow([ImportantInformationPage])
    end

    def run_flow(flow)
      flow.each do |klass|
        begin
          mi_bridges_page = klass.new(snap_application, logger: logger)
          mi_bridges_page.setup
          mi_bridges_page.fill_in_required_fields
          mi_bridges_page.continue
        rescue MiBridges::Errors::TooManyAttempts => e
          save_error(e, mi_bridges_page)
          raise e
        rescue StandardError => e
          save_error(e, mi_bridges_page)
          debug(e)
        end
      end
    end

    def logger=(logger)
      @logger = if logger.present?
                  logger
                else
                  LoggerFactory.create(level: level, output: STDOUT)
                end
    end

    def level
      if ENV["DEBUG_DRIVE"] == "true"
        Logger::DEBUG
      else
        Logger::INFO
      end
    end

    def save_error(e, mi_bridges_page)
      latest_drive_attempt.
        driver_errors.
        create(
          error_class: e.class.to_s,
          error_message: e.message,
          page_class: mi_bridges_page.class.to_s,
          page_html: page.html,
          driven_at: latest_drive_attempt.driven_at,
        )
    end

    def debug(e)
      if ENV["DEBUG_DRIVE"] == "true"
        # rubocop:disable Debugger
        binding.pry
        # rubocop:enable Debugger
      else
        logger.log(e.backtrace)
        raise e
      end
    end

    attr_reader :snap_application, :logger

    def setup
      Capybara.default_driver = ENV.fetch("WEB_DRIVER", "chrome").to_sym
      if latest_drive_attempt.blank?
        MiBridges::Driver::Services::DriverApplicationFactory.new(
          snap_application: snap_application,
        ).run
      end
    end

    def find_page_klass
      klass = APPLY_FLOW.detect do |page|
        page_title == page.title ||
          page_title.match?(page.title)
      end

      if klass.nil?
        raise MiBridges::Errors::PageNotFoundError
      else
        klass
      end
    end

    def page_title
      page.find("h1").text
    end

    def teardown
      if ENV["RUN_MI_BRIDGES_TEST"] != "true"
        base_page.close
      end
    end

    def base_page
      MiBridges::Driver::BasePage.new(snap_application, logger: logger)
    end
  end
end
