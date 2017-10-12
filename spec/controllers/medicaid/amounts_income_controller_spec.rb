require "rails_helper"

RSpec.describe Medicaid::AmountsIncomeController do
  describe "#edit" do
    context "client is has no income" do
      it "redirects to next step" do
        medicaid_application = create(
          :medicaid_application,
          employed: false,
          self_employed: false,
          unemployment_income: false,
        )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to redirect_to("/steps/medicaid/amounts-expenses")
      end
    end

    context "client has income" do
      it "renders edit" do
        medicaid_application = create(
          :medicaid_application,
          employed: false,
          self_employed: true,
          unemployment_income: false,
        )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to render_template(:edit)
      end
    end
  end
end
