require "rails_helper"

RSpec.describe CommonApplication do
  describe "#unstable_housing?" do
    context "with stable housing" do
      it "returns false" do
        application = build(:common_application, living_situation: "stable_address")
        expect(application.unstable_housing?).to eq(false)
      end
    end

    context "when homeless" do
      it "returns true" do
        application = build(:common_application, living_situation: "homeless")
        expect(application.unstable_housing?).to eq(true)
      end
    end

    context "with temporary housing" do
      it "returns true" do
        application = build(:common_application, living_situation: "temporary_address")
        expect(application.unstable_housing?).to eq(true)
      end
    end

    context "when not answered" do
      it "returns false" do
        application = build(:common_application)
        expect(application.unstable_housing?).to eq(false)
      end
    end
  end
end
