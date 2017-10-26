require "rails_helper"

RSpec.describe Medicaid::IncomeOtherIncomeTypeController do
  describe "#edit" do
    context "client does not have non-job income" do
      it "redirects to next step" do
        medicaid_application =
          create(:medicaid_application, anyone_other_income: false)
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to redirect_to(
          "/steps/medicaid/expenses-alimony",
        )
      end
    end

    context "client has non-job income" do
      it "renders edit" do
        medicaid_application =
          create(:medicaid_application, anyone_other_income: true)
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to render_template(:edit)
      end
    end
  end
end
