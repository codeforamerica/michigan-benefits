require "rails_helper"

RSpec.describe Integrated::OngoingMedicalExpensesController do
  describe "edit" do
    it "assigns existing medical expenses" do
      current_app = create(:common_application,
        expenses: [build(:expense, expense_type: "dental")])

      session[:current_application_id] = current_app.id

      get :edit

      expect(assigns[:form].dental).to be_truthy
      expect(assigns[:form].copays).to be_falsey
    end
  end

  describe "#update" do
    context "with valid params" do
      let(:valid_params) do
        {
          dental: "1",
          copays: "0",
        }
      end

      it "creates expenses from params" do
        current_app = create(:common_application)
        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        current_app.reload
        expense_types = current_app.expenses.map(&:expense_type)

        expect(expense_types).to match_array(["dental"])
      end

      it "overwrites all existing medical expenses" do
        current_app = create(:common_application, expenses: [
                               build(:expense, expense_type: "rent"),
                               build(:expense, expense_type: "copays"),
                             ])
        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        current_app.reload
        expense_types = current_app.expenses.map(&:expense_type)

        expect(expense_types).to match_array(["dental", "rent"])
      end
    end
  end
end
