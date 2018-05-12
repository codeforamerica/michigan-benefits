require "rails_helper"

RSpec.describe Employment do
  describe "validations" do
    context "when no info provided" do
      it "is valid" do
        employment = Employment.new

        expect(employment).to be_valid
      end
    end

    context "when valid info provided" do
      it "is valid" do
        employment = Employment.new(
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
          pay_quantity: "1003aaa",
        )

        expect(employment).not_to be_valid
        expect(employment.errors[:pay_quantity]).to be_present
      end
    end

    context "when hours are provided" do
      it "is invalid if not a number" do
        employment = Employment.new(hours_per_week: "woop")

        expect(employment).not_to be_valid
        expect(employment.errors[:hours_per_week]).to be_present
      end
    end
  end
end
