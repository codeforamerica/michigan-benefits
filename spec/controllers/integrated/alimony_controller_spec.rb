require "rails_helper"

RSpec.describe Integrated::AlimonyController do
  describe "#update" do
    context "when alimony is true" do
      let(:valid_params) do
        {
          alimony: "true",
        }
      end

      it "adds alimony as an expense" do
        current_app = create(:common_application)
        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        current_app.reload
        expense_types = current_app.expenses.map(&:expense_type)

        expect(expense_types).to match_array(["alimony"])
      end

      context "when alimony expense already exists" do
        it "does not create an additional expense" do
          current_app = create(:common_application,
            expenses: [build(:expense, expense_type: "alimony")])

          session[:current_application_id] = current_app.id

          put :update, params: { form: valid_params }

          current_app.reload
          expense_types = current_app.expenses.map(&:expense_type)

          expect(expense_types).to match_array(["alimony"])
        end
      end
    end

    context "when alimony is false" do
      let(:valid_params) do
        {
          alimony: "false",
        }
      end

      it "removes alimony as an expense" do
        current_app = create(:common_application,
          expenses: [build(:expense, expense_type: "alimony")])

        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        current_app.reload
        expense_types = current_app.expenses.map(&:expense_type)

        expect(expense_types).to match_array([])
      end
    end
  end
end
