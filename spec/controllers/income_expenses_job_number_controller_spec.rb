require "rails_helper"

RSpec.describe Medicaid::IncomeJobNumberController do
  describe "#edit" do
    context "client is not employed" do
      it "redirects to next step" do
        medicaid_application = create(:medicaid_application, employed: false)
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to redirect_to(
          "/steps/medicaid/income-job-number-continued",
        )
      end
    end

    context "client is employed" do
      it "renders edit" do
        medicaid_application = create(:medicaid_application, employed: true)
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to render_template(:edit)
      end
    end
  end
end
