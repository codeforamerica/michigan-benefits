require "rails_helper"

RSpec.describe Medicaid::IncomeOtherIncomeTypeController do
  describe "#current_member" do
    it "defaults to the first member with other income" do
      medicaid_application = create(
        :medicaid_application,
        anyone_other_income: true,
      )
      _primary_member = create(
        :member,
        other_income: false,
        benefit_application: medicaid_application,
      )
      other_income_member = create(
        :member,
        other_income: true,
        benefit_application: medicaid_application,
      )

      session[:medicaid_application_id] = medicaid_application.id

      expect(subject.current_member).to eq other_income_member
    end

    it "finds member from querystring" do
      medicaid_application = create(
        :medicaid_application,
        anyone_other_income: true,
      )
      _joel = create(:member, benefit_application: medicaid_application)
      jessie = create(:member, benefit_application: medicaid_application)

      session[:medicaid_application_id] = medicaid_application.id

      get :edit, params: { member: jessie.id }

      expect(subject.current_member).to eq jessie
    end

    it "finds member from posted form" do
      medicaid_application = create(
        :medicaid_application,
        anyone_other_income: true,
      )
      _joel = create(:member, benefit_application: medicaid_application)
      jessie = create(
        :member,
        benefit_application: medicaid_application,
        other_income_types: [],
      )

      session[:medicaid_application_id] = medicaid_application.id

      put :update, params: {
        step: {
          id: jessie.id,
          unemployment: "1",
        },
      }

      expect(subject.current_member).to eq jessie
      expect(jessie.reload.other_income_types).to eq(["unemployment"])
    end
  end

  describe "#edit" do
    context "client does not have non-job income" do
      it "redirects to next step" do
        medicaid_application = create(
          :medicaid_application,
          anyone_other_income: false,
          members: [build(:member, other_income: false)],
        )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to redirect_to(
          "/steps/medicaid/expenses-alimony",
        )
      end
    end

    context "client has non-job income" do
      it "renders edit" do
        medicaid_application = create(
          :medicaid_application,
          anyone_other_income: true,
          members: [build(:member, other_income: true)],
        )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to render_template(:edit)
      end
    end
  end
end
