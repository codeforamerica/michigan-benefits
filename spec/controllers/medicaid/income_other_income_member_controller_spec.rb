require "rails_helper"

RSpec.describe Medicaid::IncomeOtherIncomeMemberController, type: :controller do
  describe "#next_path" do
    it "is the citizen selector page path" do
      expect(subject.next_path).to eq "/steps/medicaid/income-other-income-type"
    end
  end

  describe "#edit" do
    context "nobody in the home has other income" do
      it "skips this page" do
        medicaid_application =
          create(
            :medicaid_application,
            anyone_other_income: false,
          )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to redirect_to(subject.next_path)
      end
    end

    context "someone in the home has other income" do
      context "multiple members in the household" do
        it "renders :edit" do
          medicaid_application = create(
            :medicaid_application,
            anyone_other_income: true,
          )
          create_list(:member, 2, benefit_application: medicaid_application)
          session[:medicaid_application_id] = medicaid_application.id

          get :edit

          expect(response).to render_template(:edit)
        end
      end

      context "single member household" do
        context "member has other income" do
          it "skips this page" do
            member = create(:member, other_income: true)
            medicaid_application = create(
              :medicaid_application,
              members: [member],
              anyone_other_income: true,
            )
            session[:medicaid_application_id] = medicaid_application.id

            get :edit

            expect(response).to redirect_to(subject.next_path)
          end
        end

        context "member does not have other income" do
          it "skips this page" do
            member = create(:member, other_income: false)
            medicaid_application = create(
              :medicaid_application,
              members: [member],
              anyone_other_income: false,
            )
            session[:medicaid_application_id] = medicaid_application.id

            get :edit

            expect(response).to redirect_to(subject.next_path)
          end
        end
      end
    end
  end
end
