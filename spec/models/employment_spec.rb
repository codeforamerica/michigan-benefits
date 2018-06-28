require "rails_helper"

RSpec.describe Employment do
  describe "validations" do
    let(:member) { build(:member) }

    context "when only applicant member is provided" do
      it "is valid" do
        employment = Employment.new(application_member: member)

        expect(employment).to be_valid
      end
    end

    context "when valid info provided" do
      it "is valid" do
        employment = Employment.new(
          application_member: member,
          hourly_or_salary: "hourly",
          pay_quantity: "100",
          hours_per_week: 10,
        )

        expect(employment).to be_valid
      end
    end

    context "when pay quantity provided" do
      it "is invalid if invalid dollar amount" do
        employment = Employment.new(
          application_member: member,
          pay_quantity: "1003aaa",
        )

        expect(employment).not_to be_valid
        expect(employment.errors[:pay_quantity]).to be_present
      end
    end
  end
end
