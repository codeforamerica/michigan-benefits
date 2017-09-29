require "rails_helper"

RSpec.describe HourlyIncomeCalculator do
  describe "#run" do
    context "pay quantity is nil" do
      it "returns zero" do
        amount = HourlyIncomeCalculator.new(
          pay_quantity: nil,
          hours_per_week: nil,
          pay_interval: nil,
        ).run

        expect(amount).to eq 0
      end
    end

    context "pay interval is hourly" do
      it "returns the pay quantity" do
        pay_quantity = 1
        hours_per_week = 100

        amount = HourlyIncomeCalculator.new(
          pay_quantity: pay_quantity,
          hours_per_week: hours_per_week,
          pay_interval: "Hourly",
        ).run

        expect(amount).to eq 1
      end
    end

    context "pay interval is every two weeks" do
      it "divides the quantity by hours per week times 2" do
        pay_quantity = 200
        hours_per_week = 100

        amount = HourlyIncomeCalculator.new(
          pay_quantity: pay_quantity,
          hours_per_week: hours_per_week,
          pay_interval: "Every Two Weeks",
        ).run

        expect(amount).to eq 1
      end
    end

    context "pay interval is twice a month" do
      it "divides the quantity by hours per week times 2" do
        pay_quantity = 200
        hours_per_week = 100

        amount = HourlyIncomeCalculator.new(
          pay_quantity: pay_quantity,
          hours_per_week: hours_per_week,
          pay_interval: "Twice a Month",
        ).run

        expect(amount).to eq 1
      end
    end

    context "pay interval is weekly" do
      it "divides the quantity by hours per week" do
        pay_quantity = 100
        hours_per_week = 100

        amount = HourlyIncomeCalculator.new(
          pay_quantity: pay_quantity,
          hours_per_week: hours_per_week,
          pay_interval: "Weekly",
        ).run

        expect(amount).to eq 1
      end
    end

    context "pay interval is monthly" do
      it "returns quantity divided by hours/week times average weeks/month" do
        pay_quantity = 100
        hours_per_week = 10

        amount = HourlyIncomeCalculator.new(
          pay_quantity: pay_quantity,
          hours_per_week: hours_per_week,
          pay_interval: "Monthly",
        ).run

        expect(amount).to eq 2.31
      end
    end
  end
end
