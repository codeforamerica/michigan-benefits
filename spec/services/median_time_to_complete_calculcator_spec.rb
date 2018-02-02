require "rails_helper"

RSpec.describe MedianTimeToCompleteCalculator do
  describe "#run" do
    context "for no applications" do
      it "returns nil" do
        time = MedianTimeToCompleteCalculator.new([]).run

        expect(time).to be_nil
      end
    end

    context "for odd number of applications" do
      it "returns the median time, rounded to nearest minute" do
        start_time = DateTime.new(2018, 1, 2, 3, 0)
        end_time_one = DateTime.new(2018, 1, 2, 3, 10, 15)
        end_time_two = DateTime.new(2018, 1, 2, 3, 13, 35)
        end_time_three = DateTime.new(2018, 1, 2, 3, 15, 45)

        applications = [
          build(:snap_application,
                 created_at: start_time,
                 signed_at: end_time_one),
          build(:snap_application,
                 created_at: start_time,
                 signed_at: end_time_two),
          build(:medicaid_application,
                 created_at: start_time,
                 signed_at: end_time_three),
        ]

        time = MedianTimeToCompleteCalculator.new(applications).run

        expect(time).to eq(14)
      end
    end

    context "for even number of applications" do
      it "returns the average of two closest mean times" do
        start_time = DateTime.new(2018, 1, 2, 3, 0)
        end_time_one = DateTime.new(2018, 1, 2, 3, 10, 15)
        end_time_two = DateTime.new(2018, 1, 2, 3, 13, 30)
        end_time_three = DateTime.new(2018, 1, 2, 3, 15, 0o0)
        end_time_four = DateTime.new(2018, 1, 2, 3, 17, 0o0)

        applications = [
          build(:snap_application,
                created_at: start_time,
                signed_at: end_time_one),
          build(:snap_application,
                created_at: start_time,
                signed_at: end_time_two),
          build(:medicaid_application,
                created_at: start_time,
                signed_at: end_time_three),
          build(:medicaid_application,
                created_at: start_time,
                signed_at: end_time_four),
        ]

        time = MedianTimeToCompleteCalculator.new(applications).run

        expect(time).to eq(14)
      end
    end
  end
end
