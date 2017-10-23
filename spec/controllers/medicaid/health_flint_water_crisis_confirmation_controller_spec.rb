require "rails_helper"

RSpec.describe Medicaid::HealthFlintWaterCrisisConfirmationController do
  describe "#next_path" do
    it "is the insurance current path" do
      expect(subject.next_path).to eq(
        "/steps/medicaid/tax-filing",
      )
    end
  end

  describe "#edit" do
    context "affected by flint water crisis" do
      it "renders the page" do
        medicaid_application = create(
          :medicaid_application,
          flint_water_crisis: true,
        )

        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to render_template(:edit)
      end
    end

    context "not affected by flint water crisis" do
      it "redirects to the next page" do
        medicaid_application = create(
          :medicaid_application,
          flint_water_crisis: false,
        )

        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to redirect_to(subject.next_path)
      end
    end
  end
end
