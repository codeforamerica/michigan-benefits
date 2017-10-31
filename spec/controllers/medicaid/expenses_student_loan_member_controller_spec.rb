require "rails_helper"

RSpec.describe Medicaid::ExpensesStudentLoanMemberController do
  describe "#next_path" do
    it "is the amounts overview page path" do
      expect(subject.next_path).to eq "/steps/medicaid/amounts-overview"
    end
  end

  describe "#edit" do
    context "no one pays student loan interest" do
      it "skips this page" do
        medicaid_application =
          create(
            :medicaid_application,
            anyone_pay_student_loan_interest: false,
          )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to redirect_to(subject.next_path)
      end
    end

    context "someone pays student loan interest" do
      context "multiple members in the household" do
        it "renders :edit" do
          medicaid_application = create(
            :medicaid_application,
            anyone_pay_student_loan_interest: true,
          )
          create_list(:member, 2, benefit_application: medicaid_application)
          session[:medicaid_application_id] = medicaid_application.id

          get :edit

          expect(response).to render_template(:edit)
        end
      end

      context "single member household" do
        it "skips this page if they pay student loan interest" do
          medicaid_application = create(
            :medicaid_application,
            anyone_pay_student_loan_interest: true,
          )
          create(:member, benefit_application: medicaid_application)
          session[:medicaid_application_id] = medicaid_application.id

          get :edit

          expect(response).to redirect_to(subject.next_path)
        end

        it "skips this page if they are not a citizen" do
          medicaid_application = create(
            :medicaid_application,
            anyone_pay_student_loan_interest: false,
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
