require "rails_helper"

RSpec.describe WhoIsVeteranForm do
  describe "validations" do
    context "when no members are veteran" do
      it "is invalid" do
        members = build_list(:household_member, 2, veteran: "no")
        form = WhoIsVeteranForm.new(members: members)

        expect(form).to_not be_valid
      end
    end

    context "when at least one member is veteran" do
      it "is valid" do
        members = build_list(:household_member, 2, veteran: "yes")
        form = WhoIsVeteranForm.new(members: members)

        expect(form).to be_valid
      end
    end
  end
end
