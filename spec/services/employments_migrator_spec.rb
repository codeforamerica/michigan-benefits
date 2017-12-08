require "rails_helper"

RSpec.describe EmploymentsMigrator do
  describe "#run" do
    context "employments data exists in array fields" do
      it "copies data to the employments table" do
        member = build(
          :member,
          employed_number_of_jobs: 3,
          employed_employer_names: %w(BART Muni SamTrans),
          employed_pay_quantities: %w(40 500 6000),
          employed_payment_frequency: %w(Hourly Weekly Monthly),
        )
        create(:medicaid_application, members: [member])

        EmploymentsMigrator.new.run

        expect(member.employments.count).to eq(3)

        first_job = member.employments.first
        expect(first_job.employer_name).to eq("BART")
        expect(first_job.payment_frequency).to eq("Hourly")
        expect(first_job.pay_quantity).to eq("40")

        second_job = member.employments.second
        expect(second_job.employer_name).to eq("Muni")
        expect(second_job.payment_frequency).to eq("Weekly")
        expect(second_job.pay_quantity).to eq("500")

        third_job = member.employments.third
        expect(third_job.employer_name).to eq("SamTrans")
        expect(third_job.payment_frequency).to eq("Monthly")
        expect(third_job.pay_quantity).to eq("6000")
      end
    end

    context "member has nil number of jobs" do
      it "does not create employment records" do
        member = build(
          :member,
          employed_number_of_jobs: nil,
        )
        create(:medicaid_application, members: [member])
        EmploymentsMigrator.new.run
        expect(member.employments.count).to eq(0)
      end
    end

    context "member has zero jobs" do
      it "does not create employment records" do
        member = build(
          :member,
          employed_number_of_jobs: 0,
        )
        create(:medicaid_application, members: [member])
        EmploymentsMigrator.new.run
        expect(member.employments.count).to eq(0)
      end
    end

    context "it is run twice" do
      it "does not create new records the second time" do
        member = build(
          :member,
          employed_number_of_jobs: 3,
          employed_employer_names: %w(BART Muni SamTrans),
          employed_pay_quantities: %w(40 500 6000),
          employed_payment_frequency: %w(Hourly Weekly Monthly),
        )
        create(:medicaid_application, members: [member])

        EmploymentsMigrator.new.run

        expect(member.employments.count).to eq(3)

        EmploymentsMigrator.new.run

        expect(member.employments.count).to eq(3)
      end
    end
  end
end
