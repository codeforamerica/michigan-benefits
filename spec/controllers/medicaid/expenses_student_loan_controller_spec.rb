require "rails_helper"

RSpec.describe Medicaid::ExpensesStudentLoanController, type: :controller do
  include_examples "application required"

  describe "#next_path" do
    it "is the citizen selector page path" do
      expect(subject.next_path).to eq(
        "/steps/medicaid/expenses-student-loan-member",
      )
    end
  end

  describe "#update" do
    context "single member household" do
      context "pays student loan interest" do
        it "updates the member" do
          member = create(:member)

          medicaid_application = create(
            :medicaid_application,
            members: [member],
          )
          session[:medicaid_application_id] = medicaid_application.id

          put :update, params: {
            step: {
              anyone_pay_student_loan_interest: true,
            },
          }

          member.reload

          expect(member.pay_student_loan_interest).to eq true
        end
      end

      context "does not pay student loan interest" do
        it "updates the member" do
          member = create(:member)

          medicaid_application = create(
            :medicaid_application,
            members: [member],
          )
          session[:medicaid_application_id] = medicaid_application.id

          put :update, params: {
            step: {
              anyone_pay_student_loan_interest: false,
            },
          }

          member.reload

          expect(member.pay_student_loan_interest).to eq false
        end
      end
    end
  end
end
