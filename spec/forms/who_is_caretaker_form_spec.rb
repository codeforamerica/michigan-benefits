require "rails_helper"

RSpec.describe WhoIsCaretakerForm do
  describe "validations" do
    context "when no members are caretaker" do
      it "is invalid" do
        members = build_list(:household_member, 2, caretaker: "no")
        form = WhoIsCaretakerForm.new(members: members)

        expect(form).to_not be_valid
      end
    end

    context "when at least one member is caretaker" do
      it "is valid" do
        members = build_list(:household_member, 2, caretaker: "yes")
        form = WhoIsCaretakerForm.new(members: members)

        expect(form).to be_valid
      end
    end
  end
end
