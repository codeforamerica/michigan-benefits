require "rails_helper"

RSpec.describe FoodAssistanceSupplement do
  describe "pdf component" do
    let(:subject) do
      FoodAssistanceSupplement.new(double("fake application"))
    end

    it_should_behave_like "pdf component"
  end

  describe "#fill?" do
    it "responds to fill? and returns true" do
      form = FoodAssistanceSupplement.new(double("fake application"))
      expect(form.fill?).to be_truthy
    end
  end

  describe "#attributes" do
    let(:housing_expense) do
      build(:expense, expense_type: "rent", amount: 600)
    end

    let(:attributes) do
      common_application = create(:common_application,
        expenses: [
          build(:expense, expense_type: "phone"),
          housing_expense,
        ],
        members: [
          build(:household_member,
            :in_food_household,
            first_name: "Julie",
            last_name: "Tester",
            expenses: [housing_expense]),
          build(:household_member,
            first_name: "Jonny",
            last_name: "Tester",
            requesting_food: "yes",
            expenses: [housing_expense]),
        ])

      FoodAssistanceSupplement.new(common_application).attributes
    end

    it "returns a hash with basic information" do
      expect(attributes).to include(
        anyone_buys_food_separately: "Yes",
        anyone_buys_food_separately_names: "Jonny Tester",
        anyone_pays_utilities: "Yes",
        pays_utilities_phone: "Yes",
        anyone_pays_housing_expenses: "Yes",
        pays_housing_expenses_rent: "Yes",
        first_member_pays_housing_expenses_name: "Julie Tester, Jonny Tester",
        first_member_pays_housing_expenses_expense_type: "Rent",
        first_member_pays_housing_expenses_amount: 600,
        first_member_pays_housing_expenses_payment_frequency: "Monthly",
      )
    end
  end
end
