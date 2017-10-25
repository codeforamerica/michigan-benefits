require "rails_helper"

RSpec.describe Medicaid::IntroCitizenMemberController, type: :controller do
  describe "#next_path" do
    it "is the citizen selector page path" do
      expect(subject.next_path).to eq "/steps/medicaid/insurance-needed"
    end
  end

  describe "#edit" do
    context "everyone in the home is a citizen" do
      it "skips this page" do
        medicaid_application =
          create(
            :medicaid_application,
            everyone_a_citizen: true,
          )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to redirect_to(subject.next_path)
      end
    end

    context "someone in the home is not a US citizen" do
      context "multiple members in the household" do
        it "renders :edit" do
          medicaid_application = create(
            :medicaid_application,
            everyone_a_citizen: false,
          )
          create_list(:member, 2, benefit_application: medicaid_application)
          session[:medicaid_application_id] = medicaid_application.id

          get :edit

          expect(response).to render_template(:edit)
        end
      end

      context "single member household" do
        it "skips this page if they are a citizen" do
          medicaid_application = create(
            :medicaid_application,
            everyone_a_citizen: true,
          )
          create(:member, benefit_application: medicaid_application)
          session[:medicaid_application_id] = medicaid_application.id

          get :edit

          expect(response).to redirect_to(subject.next_path)
        end

        it "skips this page if they are not a citizen" do
          medicaid_application = create(
            :medicaid_application,
            everyone_a_citizen: false,
          )
          create(:member, benefit_application: medicaid_application)
          session[:medicaid_application_id] = medicaid_application.id

          get :edit

          expect(response).to redirect_to(subject.next_path)
        end
      end
    end
  end
end
