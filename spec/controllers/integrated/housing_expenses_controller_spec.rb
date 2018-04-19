require "rails_helper"

RSpec.describe Integrated::HousingExpensesController do
  describe "edit" do
    it "assigns existing housing expenses" do
      current_app = create(:common_application,
        expenses: [build(:expense, expense_type: "rent")],
      )

      session[:current_application_id] = current_app.id

      get :edit

      expect(assigns[:form].rent).to be_truthy
      expect(assigns[:form].mortgage).to be_falsey
    end
  end

  describe "#update" do
    context "with valid params" do
      let(:valid_params) do
        {
          rent: "1",
          mortgage: "0",
        }
      end

      it "creates expenses from params" do
        current_app = create(:common_application)
        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        current_app.reload
        expense_types = current_app.expenses.map(&:expense_type)

        expect(expense_types).to match_array(["rent"])
      end

      it "overwrites all existing housing expenses" do
        current_app = create(:common_application, expenses: [
          build(:expense, expense_type: "phone"),
          build(:expense, expense_type: "mortgage"),
        ])
        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        current_app.reload
        expense_types = current_app.expenses.map(&:expense_type)

        expect(expense_types).to match_array(["phone", "rent"])
      end
    end
  end
end
