require "rails_helper"

RSpec.describe HouseholdAddMember do
  let(:subject) do
    HouseholdAddMember.new(
      first_name: "Light",
      last_name: "Bulb",
      requesting_food_assistance: "true",
    )
  end

  include_examples "social security number"

  context "relationship is included in list" do
    it "is valid" do
      valid_relationship = "Roommate"

      step = HouseholdAddMember.new(relationship: valid_relationship)
      step.valid?

      expect(step.errors[:relationship]).to eq []
    end
  end

  context "relationship is included in list" do
    it "is valid" do
      invalid_relationship = "Lamp"

      step = HouseholdAddMember.new(relationship: invalid_relationship)
      step.valid?

      expect(step.errors[:relationship]).to eq ["is not included in the list"]
    end
  end

  context "relationship is nil" do
    it "is valid" do
      step = HouseholdAddMember.new(relationship: nil)
      step.valid?

      expect(step.errors[:relationship]).to eq []
    end
  end
end
