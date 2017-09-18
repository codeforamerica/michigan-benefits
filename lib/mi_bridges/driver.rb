# frozen_string_literal: true

require "capybara/rails"
require "capybara/drivers/chrome"
require "capybara/drivers/headless_chrome"

module MiBridges
  class Driver
    SIGN_UP_FLOW = [
      HomePage,
      CreateAccountPage,
      CreateAccountConfirmationPage,
      LogInPage,
      PrivacyPinPage,
      BenefitsOverviewPage,
      FraudPenaltyAffidavitPage,
    ].freeze

    LOGIN_FLOW = [
      HomeLogInPage,
      MultiFactorAuthPage,
      SecurityQuestionsPage,
      PrivacyPinPage,
      ContinueApplicationPage,
      GoBackToApplicationPage,
    ].freeze

    APPLY_FLOW = [
      StartPage,
      BenefitsSelectorPage,
      ProgramBenefitsPage,
      PersonalInformationPage,
      BasicInformationSummaryPage,
      PeopleListedPage,
      HouseholdMembersSummaryPage,
      JobIncomeInformationPage,
      JobIncomeSummaryPage,
      MoneyOtherSourcesPage,
      MoneyOtherSourcesSummaryPage,
      HouseholdMemberQuestionsPage,
      DisabilityOrBlindnessReviewPage,
      LiquidAssetsPage,
      LiquidAssetsSummaryPage,
      OtherAssetsPage,
      OtherAssetsSummaryPage,
      HousingUtilityBillsPage,
      HousingBillsPage,
      UtilityBillsPage,
      HousingUtilityBillsSummaryPage,
      YourOtherBillsExpensesPage,
      YourOtherBillsExpensesSummaryPage,
      SchoolDetailsPage,
      VeteranInformationPage,
      OtherInformationPage,
      OtherInformationSummaryPage,
      AdditionalInformationPage,
      FinishPage,
      SubmitPage,
    ].freeze

    def initialize(snap_application:, logger: nil)
      @snap_application = snap_application
      self.logger = logger
    end

    def run
      setup

      page_classes = SIGN_UP_FLOW + APPLY_FLOW

      page_classes.each do |klass|
        begin
          page = klass.new(@snap_application, logger: logger)
          page.setup
          page.fill_in_required_fields
          page.continue
        rescue StandardError => e
          # rubocop:disable Debugger
          binding.pry if ENV["DEBUG_DRIVE"]
          # rubocop:enable Debugger
          throw e
        end
      end

      teardown
    end

    private

    def logger=(logger)
      return @logger = logger if logger.present?
      logger = ActiveSupport::Logger.new(STDOUT)
      logger.level = if ENV["DEBUG_DRIVE"] = "true"
                       Logger::DEBUG
                     else
                       Logger::INFO
                     end
      logger.formatter = Rails.application.config.log_formatter
      @logger = ActiveSupport::TaggedLogging.new(logger)
    end

    attr_reader :snap_application, :logger

    def setup
      Capybara.default_driver = ENV.fetch("WEB_DRIVER", "chrome").to_sym
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
