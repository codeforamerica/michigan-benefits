require "rails_helper"

RSpec.describe JobDetailsForm do
  describe "validations" do
    context "when no info provided" do
      it "is valid" do
        member = create(:household_member)
        form = JobDetailsForm.new(id: member.id.to_s, employments: [], valid_members: [member])

        expect(form).to be_valid
      end
    end

    context "when valid info provided" do
      it "is valid" do
        member = create(:household_member)
        form = JobDetailsForm.new(
          id: member.id.to_s,
          employments: [
            Employment.new(employer_name: "ABC Corp",
                           hourly_or_salary: "hourly",
                           payment_frequency: "week",
                           pay_quantity: "100",
                           hours_per_week: "ten"),
          ],
          valid_members: [member],
        )

        expect(form).to be_valid
      end
    end

    context "when pay frequency provided" do
      it "is invalid if invalid dollar amount" do
        form = JobDetailsForm.new(employments: [
                                    Employment.new(payment_frequency: "woop"),
                                  ],
                                  valid_members: [create(:household_member)])

        expect(form).not_to be_valid
        expect(form.employments.first.errors[:payment_frequency]).to be_present
      end
    end

    context "when id is included in member ids" do
      it "is valid" do
        member = create(:household_member)
        form = JobDetailsForm.new(id: member.id.to_s, employments: [], valid_members: [member])

        expect(form).to be_valid
      end
    end

    context "when id is not included in member ids" do
      it "is invalid" do
        form = JobDetailsForm.new(id: "foo", employments: [], valid_members: [create(:household_member)])

        expect(form).to_not be_valid
        expect(form.errors[:id]).to be_present
      end
    end

    context "when a pay quantity is not a dollar amount" do
      it "is invalid" do
        member = create(:household_member)
        form = JobDetailsForm.new(
          id: member.id.to_s,
          employments: [
            Employment.new(employer_name: "ABC Corp",
                           hourly_or_salary: "hourly",
                           payment_frequency: "week",
                           pay_quantity: "9.1",
                           hours_per_week: "10"),
          ],
          valid_members: [member],
        )
        expect(form).to_not be_valid
        expect(form.employments.first.errors[:pay_quantity_hourly]).to be_present
      end
    end
  end
end
