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

        weekly_pay_times_average_weeks_per_month = 433.0
        expect(member.monthly_income).to eq(
          weekly_pay_times_average_weeks_per_month,
        )
      end
    end

    describe "#first_name_and_age" do
      it "returns first name and age" do
        time = Time.utc(2008, 9, 1, 10, 5, 0)
        Timecop.freeze(time) do
          member = build(
            :member,
            first_name: "Lala",
            birthday: DateTime.parse("June 20, 1990"),
          )

          expect(member.first_name_and_age).to eq "Lala (age 18)"
        end
      end
    end
  end
end
