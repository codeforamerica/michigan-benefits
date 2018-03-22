class FormNavigation
  MAIN = {
    "Introduction" => [
      Integrated::BeforeYouStartController,
      Integrated::IntroduceYourselfController,
      Integrated::ResideInStateController,
      Integrated::ResideOutOfStateController,
      Integrated::LivingSituationController,
      Integrated::BenefitsIntroController,
      Integrated::HouseholdMembersOverviewController,
    ],
    "Food Assistance" => [
      Integrated::FoodAssistanceController,
      Integrated::BuyAndPrepareFoodWithOtherPersonController,
      Integrated::ShareFoodCostsWithHouseholdController,
      Integrated::BuyAndPrepareFoodSeparatelyController,
      Integrated::ReviewFoodAssistanceMembersController,
    ],
    "Healthcare" => [
      Integrated::HealthcareController,
      Integrated::DeclineHealthcareController,
      Integrated::FileTaxesNextYearController,
      Integrated::IncludeAnyoneElseOnTaxesController,
      Integrated::DescribeTaxRelationshipsController,
    ],
    "Finish" => [
      Integrated::ApplicationSubmittedController,
    ],
  }.freeze

  OFF_MAIN = [
    Integrated::AddHouseholdMemberController,
    Integrated::RemoveHouseholdMemberController,
    Integrated::AddFoodMemberController,
    Integrated::RemoveFoodMemberController,
    Integrated::AddHealthcareMemberController,
  ].freeze

  class << self
    delegate :first, to: :forms

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
