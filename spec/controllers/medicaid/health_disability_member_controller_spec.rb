require "rails_helper"

RSpec.describe Medicaid::HealthDisabilityMemberController, type: :controller do
  describe "#next_path" do
    it "is the pregnancy question page path" do
      expect(subject.next_path).to eq "/steps/medicaid/health-pregnancy"
    end
  end

  describe "#edit" do
    context "no one is disabled" do
      it "skips this page" do
        medicaid_application =
          create(
            :medicaid_application,
            anyone_disabled: false,
          )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to redirect_to(subject.next_path)
      end
    end

    context "someone in the home is disabled" do
      context "multiple members in the household" do
        it "renders :edit" do
          medicaid_application = create(
            :medicaid_application,
            anyone_disabled: true,
          )
          create_list(:member, 2, benefit_application: medicaid_application)
          session[:medicaid_application_id] = medicaid_application.id

          get :edit

          expect(response).to render_template(:edit)
        end
      end

      context "single member household" do
        it "skips this page if they are disabled" do
          medicaid_application = create(
            :medicaid_application,
            anyone_disabled: true,
          )
          create(:member, benefit_application: medicaid_application)
          session[:medicaid_application_id] = medicaid_application.id

          get :edit

          expect(response).to redirect_to(subject.next_path)
        end

        it "skips this page if they are not disabled" do
          medicaid_application = create(
            :medicaid_application,
            anyone_disabled: false,
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
