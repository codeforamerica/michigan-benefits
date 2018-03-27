require "rails_helper"

RSpec.describe WhoIsMarriedForm do
  describe "validations" do
    context "when no members are married" do
      it "is invalid" do
        members = build_list(:household_member, 2, married: "no")
        form = WhoIsMarriedForm.new(members: members)

        expect(form).to_not be_valid
      end
    end

    context "when at least one member is married" do
      it "is valid" do
        members = build_list(:household_member, 2, married: "yes")
        form = WhoIsMarriedForm.new(members: members)

        expect(form).to be_valid
      end
    end
  end
end
