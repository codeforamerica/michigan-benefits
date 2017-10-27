require "rails_helper"

RSpec.describe Medicaid::ExpensesAlimonyMemberController, type: :controller do
  describe "#next_path" do
    it "is the student loan expenses page path" do
      expect(subject.next_path).to eq "/steps/medicaid/expenses-student-loan"
    end
  end

  describe "#edit" do
    context "no one in the household pays alimony, child support, etc" do
      it "skips this page" do
        medicaid_application =
          create(
            :medicaid_application,
            anyone_pay_child_support_alimony_arrears: false,
          )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to redirect_to(subject.next_path)
      end
    end

    context "someone pays child support, alimony, etc" do
      context "multiple members in the household" do
        it "renders :edit" do
          medicaid_application = create(
            :medicaid_application,
            anyone_pay_child_support_alimony_arrears: true,
          )
          create_list(:member, 2, benefit_application: medicaid_application)
          session[:medicaid_application_id] = medicaid_application.id

          get :edit

          expect(response).to render_template(:edit)
        end
      end

      context "single member household" do
        it "skips this page if they pay child support, alimony, arrears" do
          medicaid_application = create(
            :medicaid_application,
            anyone_pay_child_support_alimony_arrears: true,
          )
          create(:member, benefit_application: medicaid_application)
          session[:medicaid_application_id] = medicaid_application.id

          get :edit

          expect(response).to redirect_to(subject.next_path)
        end

        it "skips this page if they don't pay child support, alimony, etc" do
          medicaid_application = create(
            :medicaid_application,
            anyone_pay_child_support_alimony_arrears: false,
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
