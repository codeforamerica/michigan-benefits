require "rails_helper"

RSpec.describe WhoIsNotCitizenForm do
  describe "validations" do
    context "when all members are citizens" do
      it "is invalid" do
        members = build_list(:household_member, 2, citizen: "yes")
        form = WhoIsNotCitizenForm.new(members: members)

        expect(form).to_not be_valid
      end
    end

    context "when at least one member is not a citizen" do
      it "is valid" do
        members = build_list(:household_member, 2, citizen: "no")
        form = WhoIsNotCitizenForm.new(members: members)

        expect(form).to be_valid
      end
    end
  end
end
