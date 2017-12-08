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
      AbsentParentDetailsPage,
      AbsentParentDetailsSummaryPage,
      AbsentParentInformationPage,
      AbsentParentSummaryPage,
      AdditionalInformationPage,
      BasicInformationSummaryPage,
      BenefitsSelectorPage,
      ConceptionPage,
      DisabilityOrBlindnessReviewPage,
      FinishPage,
      HealthHospitalizationInsurancePremiumsPage,
      HouseholdMemberQuestionsPage,
      HouseholdMembersSummaryPage,
      HousingBillsPage,
      HousingUtilityBillsPage,
      HousingUtilityBillsSummaryPage,
      InformationAboutTheChildPage,
      InpatientHospitalizationNursingCarePage,
      JobIncomeInformationPage,
      JobIncomeSummaryPage,
      LiquidAssetsPage,
      LiquidAssetsSummaryPage,
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
      OtherAssetsSummaryPage,
      OtherIncomeSummaryPage,
      OtherInformationPage,
      OtherInformationSummaryPage,
      OtherTypesOfIncomePage,
      PeopleListedPage,
      PersonalCareServicesProvidedInHomePage,
      PersonalInformationPage,
      PregnancyInformationPage,
      PrescriptionDrugsAndMedicationPage,
      ProgramBenefitsPage,
      RealPropertiesPage,
      RelationshipInformationPage,
      SchoolDetailsPage,
      StartPage,
      SubmitPage,
      UtilityBillsPage,
      VehiclesPage,
      VeteranInformationPage,
      ViewTrackAndPrintYourApplicationPage,
      YourOtherBillsExpensesPage,
      YourOtherBillsExpensesSummaryPage,
    ].freeze

    def initialize(snap_application:, logger: nil)
      @snap_application = snap_application
      self.logger = logger
    end

    def run
      setup
      begin
        sign_up_for_account
        complete_application
      rescue MiBridges::Errors::TooManyAttempts => e
        save_error(e, @page)
        raise e
      rescue StandardError => e
        save_error(e, @page)
        debug(e)
      end
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
      while page_title != SubmitPage.title
        klass = find_page_klass
        run_flow([klass])
      end

      run_flow([SubmitPage])
    end

    def run_flow(flow)
      flow.each do |klass|
        @page = klass.new(@snap_application, logger: logger)
        @page.setup
        @page.fill_in_required_fields
        @page.continue
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

    def save_error(e, page)
      return if latest_drive_attempt.nil?

      latest_drive_attempt.
        driver_errors.
        create(
          error_class: e.class.to_s,
          error_message: e.message,
          page_class: page.class.to_s,
          page_html: page.html,
          driven_at: latest_drive_attempt.driven_at,
        )
    end

    def debug(e)
      if ENV["DEBUG_DRIVE"]
        # rubocop:disable Debugger
        binding.pry
        # rubocop:enable Debugger
      else
        raise e
      end
    end

    attr_reader :snap_application, :logger

    def setup
      Capybara.default_driver = ENV.fetch("WEB_DRIVER", "chrome").to_sym
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
      @page.find("h1").text
    end

    def teardown
      if ENV["PRE_DEPLOY_TEST"] != "true"
        MiBridges::Driver::BasePage.new(snap_application, logger: logger).close
      end
    end
  end
end
