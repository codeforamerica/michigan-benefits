require "rails_helper"

RSpec.describe Medicaid::IntroMaritalStatusIndicateSpouse do
  describe "Validations" do
    context "other member is selected" do
      it "is valid" do
        member = create(:member, married: true)

        step = Medicaid::IntroMaritalStatusIndicateSpouse.new(
          member_id: member.id,
          spouse_id: 0,
        )

        expect(step).to be_valid
      end
    end

    context "member is selected" do
      it "is valid" do
        member = create(:member, married: true)
        spouse_member = create(:member, married: true)

        step = Medicaid::IntroMaritalStatusIndicateSpouse.new(
          member_id: member.id,
          spouse_id: spouse_member.id,
        )

        expect(step).to be_valid
      end
    end

    context "nobody is selected" do
      it "is invalid" do
        member = create(:member, married: true)

        step = Medicaid::IntroMaritalStatusIndicateSpouse.new(
          member_id: member.id,
          spouse_id: nil,
        )

        expect(step.valid?).to eq false
      end
    end
  end
end
