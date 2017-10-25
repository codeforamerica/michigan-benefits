require "rails_helper"

RSpec.describe Medicaid::AmountsIncomeController do
  describe "#edit" do
    context "client is has no income" do
      it "redirects to next step" do
        medicaid_application = create(
          :medicaid_application,
          anyone_employed: false,
          anyone_self_employed: false,
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
          :with_member,
          anyone_employed: false,
          anyone_self_employed: true,
          unemployment_income: false,
        )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to render_template(:edit)
      end
    end
  end

  describe "#update" do
    context "client has multiple jobs" do
      it "saves the income for each job" do
        member = create(:member, employed_number_of_jobs: 2)
        medicaid_application = create(
          :medicaid_application,
          members: [member],
          anyone_employed: true,
        )
        session[:medicaid_application_id] = medicaid_application.id
        payload = {
          step: {
            employed_monthly_income: ["111", "222"],
          },
        }

        post :update, params: payload

        medicaid_application.reload

        expect(medicaid_application.employed_monthly_income).to eq(
          ["111", "222"],
        )
      end
    end
  end
end
