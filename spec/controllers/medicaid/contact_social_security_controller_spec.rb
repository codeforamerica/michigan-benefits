require "rails_helper"

RSpec.describe Medicaid::ContactSocialSecurityController do
  describe "#edit" do
    context "client will not submitssn" do
      it "redirects to next step" do
        medicaid_application = create(:medicaid_application, submit_ssn: false)
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to redirect_to(
          "/steps/medicaid/confirmation",
        )
      end
    end

    context "client will submit ssn" do
      it "renders edit" do
        medicaid_application = create(:medicaid_application, submit_ssn: true)
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to render_template(:edit)
      end
    end
  end
end
