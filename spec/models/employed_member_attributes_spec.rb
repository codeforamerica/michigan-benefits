require "rails_helper"

RSpec.describe EmployedMemberAttributes do
  describe "#to_h" do
    it "returns the correct attributes prepended with the position" do
      member = build(
        :member,
        employment_status: "employed",
        first_name: "Foo",
        last_name: "Flace",
        employed_employer_name: "McTacoBacon R Us",
        employed_hours_per_week: 20,
        employed_pay_quantity: 100,
        employed_pay_interval: "Weekly",
        benefit_application: build(:snap_application),
      )

      position = "second"

      result = EmployedMemberAttributes.new(
        member: member,
        position: position,
      ).to_h

      expect(result).to eq(
        second_employed_full_name: "Foo Flace",
        second_employed_employer_name: "McTacoBacon R Us",
        second_employed_hours_per_week: 20,
        second_employed_hours_interval: "Yes",
        second_employed_pay_quantity: 100,
        second_employed_pay_interval_hourly: nil,
        second_employed_pay_interval_yearly: nil,
        second_employed_pay_interval_other: "Yes",
        second_employed_pay_interval_other_detail: "Weekly",
      )
    end
  end
end
