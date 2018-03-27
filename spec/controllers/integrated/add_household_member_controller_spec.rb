require "rails_helper"

RSpec.describe Integrated::AddHouseholdMemberController do
  it_behaves_like "add member controller"

  describe ".previous_path" do
    it "should be household overview path" do
      expect(controller.previous_path).to eq(household_members_overview_sections_path)
    end
  end

  describe ".next_path" do
    it "should be household overview path" do
      expect(controller.next_path).to eq(household_members_overview_sections_path)
    end
  end
end
