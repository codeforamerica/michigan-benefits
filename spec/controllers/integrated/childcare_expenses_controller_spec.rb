require "rails_helper"

RSpec.describe Integrated::ChildcareExpensesController do
  describe "#skip?" do
    context "when single-member household" do
      it "returns true" do
        application = create(:common_application, :single_member)

        skip_step = Integrated::ChildcareExpensesController.skip?(application)
        expect(skip_step).to be_truthy
      end
    end

    context "when two or more members in a household" do
      it "returns false" do
        application = create(:common_application, :multi_member)

        skip_step = Integrated::ChildcareExpensesController.skip?(application)
        expect(skip_step).to be_falsey
      end
    end
  end

  describe "#update" do
    context "when childcare is true" do
      let(:valid_params) do
        {
          childcare: "true",
        }
      end

      it "adds childcare as an expense" do
        current_app = create(:common_application)
        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        current_app.reload
        expense_types = current_app.expenses.map(&:expense_type)

        expect(expense_types).to match_array(["childcare"])
      end

      context "when childcare expense already exists" do
        it "does not create an additional expense" do
          current_app = create(:common_application,
            expenses: [build(:expense, expense_type: "childcare")])

          session[:current_application_id] = current_app.id

          put :update, params: { form: valid_params }

          current_app.reload
          expense_types = current_app.expenses.map(&:expense_type)

          expect(expense_types).to match_array(["childcare"])
        end
      end
    end

    context "when childcare is false" do
      let(:valid_params) do
        {
          childcare: "false",
        }
      end

      it "removes childcare as an expense" do
        current_app = create(:common_application,
          expenses: [build(:expense, expense_type: "childcare")])

        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        current_app.reload
        expense_types = current_app.expenses.map(&:expense_type)

        expect(expense_types).to match_array([])
      end
    end
  end
end
