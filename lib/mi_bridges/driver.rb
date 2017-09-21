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

    APPLY_FLOW = [
      AdditionalInformationPage,
      BasicInformationSummaryPage,
      BenefitsSelectorPage,
      DisabilityOrBlindnessReviewPage,
      FinishPage,
      HouseholdMemberQuestionsPage,
      HouseholdMembersSummaryPage,
      HousingBillsPage,
      HousingUtilityBillsPage,
      HousingUtilityBillsSummaryPage,
      JobIncomeInformationPage,
      JobIncomeSummaryPage,
      LiquidAssetsPage,
      LiquidAssetsSummaryPage,
      MailingAddressPage,
      MoneyOtherSourcesPage,
      MoneyOtherSourcesSummaryPage,
      MoreAboutSelfEmploymentPage,
      OtherAssetsPage,
      OtherAssetsSummaryPage,
      OtherInformationPage,
      OtherInformationSummaryPage,
      PeopleListedPage,
      PersonalInformationPage,
      PregnancyInformationPage,
      ProgramBenefitsPage,
      SchoolDetailsPage,
      StartPage,
      SubmitPage,
      UtilityBillsPage,
      VeteranInformationPage,
      YourOtherBillsExpensesPage,
      YourOtherBillsExpensesSummaryPage,
    ].freeze

    LOGIN_FLOW = [
      HomeLogInPage,
      MultiFactorAuthPage,
      SecurityQuestionsPage,
      PrivacyPinPage,
      ContinueApplicationPage,
      GoBackToApplicationPage,
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

    private

    def sign_up_for_account
      SIGN_UP_FLOW.each do |klass|
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

    def complete_application
      while page_title != SubmitPage::TITLE
        klass = find_page_klass
        page = klass.new(@snap_application, logger: logger)
        page.setup
        page.fill_in_required_fields
        page.continue
      end
    rescue StandardError => e
      debug(e)
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
      # rubocop:disable Debugger
      binding.pry if ENV["DEBUG_DRIVE"]
      # rubocop:enable Debugger
      throw e
    end

    attr_reader :snap_application, :logger

    def setup
      Capybara.default_driver = ENV.fetch("WEB_DRIVER", "chrome").to_sym
    end

    def find_page_klass
      APPLY_FLOW.detect do |page|
        page_title == page::TITLE ||
          page_title.match?(page::TITLE)
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
