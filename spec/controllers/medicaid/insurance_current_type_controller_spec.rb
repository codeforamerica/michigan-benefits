require "rails_helper"

RSpec.describe Medicaid::InsuranceCurrentTypeController do
  describe "#edit" do
    context "client is insured" do
      it "does not redirect" do
        medicaid_application = create(:medicaid_application, insured: true)
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to render_template(:edit)
      end
    end

    context "client is not insured" do
      it "redirects to next step" do
        medicaid_application = create(:medicaid_application, insured: false)
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to redirect_to(
          "/steps/medicaid/insurance-medical-expenses",
        )
      end
    end
  end
end
