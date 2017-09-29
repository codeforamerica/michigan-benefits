require "rails_helper"

RSpec.describe Member do
  describe "#monthly_income" do
    context "unemployed" do
      it "returns 0" do
        member = build(:member, employment_status: "not_employed")

        expect(member.monthly_income).to eq 0
      end
    end

    context "self employed" do
      it "returns monthly income" do
        member = build(
          :member,
          employment_status: "self_employed",
          self_employed_monthly_income: 100,
        )

        expect(member.monthly_income).to eq 100
      end
    end

    context "employed" do
      it "returns monthly income" do
        member = build(
          :member,
          employment_status: "employed",
          employed_pay_quantity: 10,
          employed_pay_interval: "Hourly",
          employed_hours_per_week: 10,
        )
        calc_double = double(run: true)
        allow(MonthlyIncomeCalculator).to receive(:new).with(
          pay_interval: "Hourly",
          pay_quantity: 10,
          hours_per_week: 10,
        ).and_return(calc_double)

        member.monthly_income

        expect(calc_double).to have_received(:run)
      end
    end

    describe "#mi_bridges_formatted_name" do
      context "name is over 10 chars" do
        it "cuts name off at 10 chars" do
          time = Time.utc(2008, 9, 1, 10, 5, 0)
          Timecop.freeze(time) do
            member = build(
              :member,
              first_name: "JacquelineR",
              birthday: DateTime.parse("June 20, 1990"),
            )

            expect(member.mi_bridges_formatted_name).to eq "Jacqueline (18)"
          end
        end
      end

      context "name is shorter than 10 chars" do
        it "returns full first name and age" do
          time = Time.utc(2008, 9, 1, 10, 5, 0)
          Timecop.freeze(time) do
            member = build(
              :member,
              first_name: "Lala",
              birthday: DateTime.parse("June 20, 1990"),
            )

            expect(member.mi_bridges_formatted_name).to eq "Lala (18)"
          end
        end
      end
    end
  end
end
