require "rails_helper"

RSpec.describe Medicaid::InsuranceCurrentTypeController do
  describe "#current_member" do
    it "defaults for first insurance holder" do
      medicaid_application = create(:medicaid_application, anyone_insured: true)
      _primary_member = create(
        :member,
        :not_insured,
        benefit_application: medicaid_application,
      )
      insured_member = create(
        :member,
        :insured,
        benefit_application: medicaid_application,
      )

      session[:medicaid_application_id] = medicaid_application.id

      expect(subject.current_member).to eq insured_member
    end

    it "finds member from querystring" do
      medicaid_application = create(:medicaid_application, anyone_insured: true)
      _joel = create(:member, benefit_application: medicaid_application)
      jessie = create(:member, benefit_application: medicaid_application)

      session[:medicaid_application_id] = medicaid_application.id

      get :edit, params: { member: jessie.id }

      expect(subject.current_member).to eq jessie
    end

    it "finds member from posted form" do
      medicaid_application = create(:medicaid_application, anyone_insured: true)
      _joel = create(:member, benefit_application: medicaid_application)
      jessie = create(:member, benefit_application: medicaid_application)

      session[:medicaid_application_id] = medicaid_application.id

      put :update, params: {
        step: {
          member_id: jessie.id,
          insurance_type: "Employer or individual plan",
        },
      }

      expect(subject.current_member).to eq jessie
    end
  end

  describe "#edit" do
    context "client is insured" do
      it "does not redirect" do
        medicaid_application = create(
          :medicaid_application,
          anyone_insured: true,
          members: [build(:member, insured: true, requesting_health_insurance: true)]
        )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to render_template(:edit)
      end
    end

    context "client is not insured" do
      it "redirects to next step" do
        medicaid_application = create(
          :medicaid_application,
          anyone_insured: false,
          members: [build(:member)],
        )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to redirect_to(
          "/steps/medicaid/insurance-medical-expenses",
        )
      end
    end
  end
end
