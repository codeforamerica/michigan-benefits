require "rails_helper"

RSpec.describe SelfEmployedMemberAttributes do
  describe "#to_h" do
    it "returns the correct attributes prepended with the position" do
      member = create(
        :member,
        employment_status: "self_employed",
        first_name: "Boo",
        last_name: "Blace",
        self_employed_profession: "Lampshade shaper",
        self_employed_monthly_income: 100,
        self_employed_monthly_expenses: 50,
      )

      position = "first"

      result = SelfEmployedMemberAttributes.new(
        member: member,
        position: position,
      ).to_h

      expect(result).to eq(
        first_self_employed_full_name: "Boo Blace",
        first_self_employed_profession: "Lampshade shaper",
        first_self_employed_monthly_income: 100.0,
        first_self_employed_monthly_expenses: "50",
      )
    end
  end
end
