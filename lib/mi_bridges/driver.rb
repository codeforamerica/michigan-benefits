# frozen_string_literal: true

require "capybara/rails"
require "capybara/drivers/chrome"
require "capybara/drivers/headless_chrome"

module MiBridges
  class Driver
    include Capybara::DSL

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
      MoreAboutDisabilityBenefitsPage,
      MoreAboutJobIncomePage,
      MoreAboutOtherIncomePage,
      MoreAboutPensionOrRetirementPage,
      MoreAboutRealPropertyPage,
      MoreAboutSelfEmploymentPage,
      MoreAboutSupplementalSecurityIncomePage,
      MoreAboutUnemploymentBenefitsPage,
      MoreAboutWorkersCompensationPage,
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
      YourOtherBillsExpensesPage,
      YourOtherBillsExpensesSummaryPage,
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
      while page_title != SubmitPage::TITLE
        klass = find_page_klass
        run_flow([klass])
      end

      run_flow([SubmitPage])
    rescue StandardError => e
      debug(e)
    end

    def run_flow(flow)
      flow.each do |klass|
        begin
          page = klass.new(@snap_application, logger: logger)
          page.setup
          page.fill_in_required_fields
          page.continue
        rescue StandardError => e
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
      if ENV["DEBUG_DRIVE"] = "true"
        Logger::DEBUG
      else
        Logger::INFO
      end
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
        page_title == page::TITLE ||
          page_title.match?(page::TITLE)
      end

      if klass.nil?
        fail MiBridges::Errors::PageNotFoundError.new(page_title)
      else
        klass
      end
    end

    def page_title
      page.find("h1").text
    end

    def teardown
      if ENV["PRE_DEPLOY_TEST"] != "true"
        MiBridges::Driver::BasePage.new(snap_application, logger: logger).close
      end
    end

    def first_driver_application_attempt?
      snap_application.driver_application.blank?
    end
  end
end
