require "rails_helper"

RSpec.describe Integrated::StudentLoanInterestController do
  describe "#update" do
    context "when student_loan_interest is true" do
      let(:valid_params) do
        {
          student_loan_interest: "true",
        }
      end

      it "adds student_loan_interest as an expense" do
        current_app = create(:common_application)
        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        current_app.reload
        expense_types = current_app.expenses.map(&:expense_type)

        expect(expense_types).to match_array(["student_loan_interest"])
      end

      context "when student_loan_interest expense already exists" do
        it "does not create an additional expense" do
          current_app = create(:common_application,
            expenses: [build(:expense, expense_type: "student_loan_interest")])

          session[:current_application_id] = current_app.id

          put :update, params: { form: valid_params }

          current_app.reload
          expense_types = current_app.expenses.map(&:expense_type)

          expect(expense_types).to match_array(["student_loan_interest"])
        end
      end
    end

    context "when student_loan_interest is false" do
      let(:valid_params) do
        {
          student_loan_interest: "false",
        }
      end

      it "removes student_loan_interest as an expense" do
        current_app = create(:common_application,
          expenses: [build(:expense, expense_type: "student_loan_interest")])

        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        current_app.reload
        expense_types = current_app.expenses.map(&:expense_type)

        expect(expense_types).to match_array([])
      end
    end
  end
end
