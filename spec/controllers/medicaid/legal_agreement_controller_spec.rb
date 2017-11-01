require "rails_helper"

RSpec.describe Medicaid::LegalAgreementController do
  describe "#update" do
    context "consent to terms is true" do
      it "is valid" do
        medicaid_application = create(:medicaid_application)
        session[:medicaid_application_id] = medicaid_application.id
        params = { consent_to_terms: "true" }

        put :update, params: { step: params }

        expect(response).to redirect_to("/steps/medicaid/sign-and-submit")
      end
    end

    context "consent to terms is false" do
      it "is invalid" do
        medicaid_application = create(:medicaid_application)
        session[:medicaid_application_id] = medicaid_application.id
        params = { consent_to_terms: "false" }

        put :update, params: { step: params }

        expect(response).to render_template(:edit)
      end
    end
  end
end
