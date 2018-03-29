require "rails_helper"

RSpec.describe WhoIsStudentForm do
  describe "validations" do
    context "when no members are student" do
      it "is invalid" do
        members = build_list(:household_member, 2, student: "no")
        form = WhoIsStudentForm.new(members: members)

        expect(form).to_not be_valid
      end
    end

    context "when at least one member is student" do
      it "is valid" do
        members = build_list(:household_member, 2, student: "yes")
        form = WhoIsStudentForm.new(members: members)

        expect(form).to be_valid
      end
    end
  end
end
