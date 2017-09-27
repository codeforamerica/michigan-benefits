require "rails_helper"

RSpec.describe IncomeDetailsPerMember do
  describe "Validations" do
    it "validates employer name on employed members" do
      working = create(
        :member,
        employment_status: "employed",
        employed_employer_name: nil,
      )
      self_employed = create(
        :member,
        employment_status: "self_employed",
        employed_employer_name: nil,
      )
      members = [working, self_employed]
      snap_application = create(:snap_application, members: members)

      step = IncomeDetailsPerMember.new(members: snap_application.members)
      step.valid?

      expect(step.members.last.errors[:employed_employer_name]).
        to eq([])
      expect(step.members.first.errors[:employed_employer_name]).
        to eq(["Make sure to answer this question"])
    end
  end
end
