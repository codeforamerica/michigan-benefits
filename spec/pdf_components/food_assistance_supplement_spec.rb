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
    let(:attributes) do
      common_application = create(:common_application, members: [
                                    build(:household_member,
                                      :in_snap_household,
                                      first_name: "Julie",
                                      last_name: "Tester"),
                                    build(:household_member,
                                      first_name: "Jonny",
                                      last_name: "Tester",
                                      requesting_food: "yes"),
                                  ])
      FoodAssistanceSupplement.new(common_application).attributes
    end

    it "returns a hash with basic information" do
      expect(attributes).to include(
        anyone_buys_food_separately: "Yes",
        anyone_buys_food_separately_names: "Jonny Tester",
      )
    end
  end
end
