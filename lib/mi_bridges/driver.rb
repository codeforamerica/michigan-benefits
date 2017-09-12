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
    ].freeze

    def initialize(snap_application:)
      @snap_application = snap_application
    end

    def run
      setup

      page_classes = SIGN_UP_FLOW + APPLY_FLOW

      page_classes.each do |klass|
        page = klass.new(@snap_application)
        page.setup
        page.fill_in_required_fields
        page.continue
      end

      teardown
    end

    private

    attr_reader :snap_application

    def setup
      Capybara.default_driver = ENV.fetch("WEB_DRIVER", "chrome").to_sym
    end

    def teardown
      MiBridges::Driver::BasePage.new(snap_application).close
    end

    def first_driver_application_attempt?
      snap_application.driver_application.blank?
    end
  end
end
