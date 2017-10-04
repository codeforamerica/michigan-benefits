require "rails_helper"

RSpec.describe MonthlyIncomeCalculator do
  describe "#run" do
    context "pay interval is nil" do
      it "returns nil" do
        amount = MonthlyIncomeCalculator.new(
          pay_quantity: 100,
          hours_per_week: nil,
          pay_interval: nil,
        ).run

        expect(amount).to eq nil
      end
    end

    context "pay quantity is nil" do
      it "returns nil" do
        amount = MonthlyIncomeCalculator.new(
          pay_quantity: nil,
          hours_per_week: nil,
          pay_interval: "Yearly",
        ).run

        expect(amount).to eq nil
      end
    end

    context "pay interval is hourly" do
      context "hours per week is nil" do
        it "returns nil" do
          pay_quantity = 1

          amount = MonthlyIncomeCalculator.new(
            pay_quantity: pay_quantity,
            hours_per_week: nil,
            pay_interval: "Hourly",
          ).run

          expect(amount).to eq nil
        end
      end

      it "multiplies pay quantity by hours/week and average weeks per month" do
        pay_quantity = 1
        hours_per_week = 100

        amount = MonthlyIncomeCalculator.new(
          pay_quantity: pay_quantity,
          hours_per_week: hours_per_week,
          pay_interval: "Hourly",
        ).run

        expect(amount).to eq 433.0
      end
    end

    context "pay interval is every two weeks" do
      it "returns pay quantity times average weeks per month times 2" do
        pay_quantity = 100

        amount = MonthlyIncomeCalculator.new(
          pay_quantity: pay_quantity,
          hours_per_week: 0,
          pay_interval: "Every Two Weeks",
        ).run

        expect(amount).to eq 216.5
      end
    end

    context "pay interval is twice a month" do
      it "returns pay quantity times average weeks per month times 2" do
        pay_quantity = 100

        amount = MonthlyIncomeCalculator.new(
          pay_quantity: pay_quantity,
          hours_per_week: 0,
          pay_interval: "Twice a Month",
        ).run

        expect(amount).to eq 216.5
      end
    end

    context "pay interval is weekly" do
      it "returns pay quantity times average weeks per month" do
        pay_quantity = 100

        amount = MonthlyIncomeCalculator.new(
          pay_quantity: pay_quantity,
          hours_per_week: 0,
          pay_interval: "Weekly",
        ).run

        expect(amount).to eq 433.0
      end
    end

    context "pay interval is monthly" do
      it "returns pay quantity" do
        pay_quantity = 100

        amount = MonthlyIncomeCalculator.new(
          pay_quantity: pay_quantity,
          hours_per_week: 0,
          pay_interval: "Monthly",
        ).run

        expect(amount).to eq 100
      end
    end

    context "pay interval is yearly" do
      it "returns pay quantity divided by months per year" do
        pay_quantity = 18

        amount = MonthlyIncomeCalculator.new(
          pay_quantity: pay_quantity,
          hours_per_week: 0,
          pay_interval: "Yearly",
        ).run

        expect(amount).to eq 1.5
      end
    end
  end
end
