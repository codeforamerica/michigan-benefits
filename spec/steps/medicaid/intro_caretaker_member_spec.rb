require "rails_helper"

RSpec.describe Medicaid::IntroCaretakerMember do
  describe "Validations" do
    context "at least one household member is a caretaker or parent" do
      it "is valid" do
        member = create(:member, caretaker_or_parent: true)
        member_not_caretaker_or_parent =
          create(:member, caretaker_or_parent: false)

        step = Medicaid::IntroCaretakerMember.new(
          members: [member, member_not_caretaker_or_parent],
        )

        expect(step).to be_valid
      end
    end

    context "no household member is a caretaker or parent" do
      it "is invalid" do
        members = create_list(:member, 2, caretaker_or_parent: false)

        step = Medicaid::IntroCaretakerMember.new(members: members)

        expect(step).not_to be_valid
      end
    end
  end
end
