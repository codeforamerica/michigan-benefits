require "rails_helper"

RSpec.describe Medicaid::HealthFlintWaterCrisisController do
  include_examples "application required"

  describe "#next_path" do
    it "is the insurance current path" do
      expect(subject.next_path).to eq(
        "/steps/medicaid/health-flint-water-crisis-confirmation",
      )
    end
  end

  describe "#update" do
    it "updates the current medicaid application" do
      medicaid_application = create(
        :medicaid_application,
        flint_water_crisis: nil,
      )
      session[:medicaid_application_id] = medicaid_application.id

      put :update, params: { step: { flint_water_crisis: true } }

      medicaid_application.reload

      expect(medicaid_application).to be_flint_water_crisis
    end
  end
end
