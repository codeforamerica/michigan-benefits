require "rails_helper"

RSpec.describe PersonalDetail do
  describe "#submitted_date" do
    context "faxed_at present" do
      it "returns a formatted date" do
        step = Success.new(faxed_at: DateTime.parse("January 30, 1900"))

        expect(step.submitted_date).to eq "01-30-1900"
      end
    end

    context "faxed_at not present" do
      it "returns nil" do
        step = Success.new(faxed_at: nil)

        expect(step.submitted_date).to eq nil
      end
    end
  end
end
