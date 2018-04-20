require "rails_helper"

RSpec.describe Integrated::UtilityExpensesController do
  describe "edit" do
    it "assigns existing utility expenses" do
      current_app = create(:common_application,
        expenses: [build(:expense, expense_type: "phone")])

      session[:current_application_id] = current_app.id

      get :edit

      expect(assigns[:form].phone).to be_truthy
      expect(assigns[:form].trash).to be_falsey
    end
  end

  describe "#update" do
    context "with valid params" do
      let(:valid_params) do
        {
          phone: "1",
          trash: "0",
        }
      end

      it "creates expenses from params" do
        current_app = create(:common_application)
        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        current_app.reload
        expense_types = current_app.expenses.map(&:expense_type)

        expect(expense_types).to match_array(["phone"])
      end

      it "overwrites all existing expenses" do
        current_app = create(:common_application, expenses: [
                               build(:expense, expense_type: "trash"),
                             ])
        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        current_app.reload
        expense_types = current_app.expenses.map(&:expense_type)

        expect(expense_types).to match_array(["phone"])
      end
    end
  end
end
