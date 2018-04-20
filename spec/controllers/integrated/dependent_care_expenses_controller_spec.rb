require "rails_helper"

RSpec.describe Integrated::DependentCareExpensesController do
  describe "#skip?" do
    context "when single-member household" do
      it "returns true" do
        application = create(:common_application, :single_member)

        skip_step = Integrated::DependentCareExpensesController.skip?(application)
        expect(skip_step).to be_truthy
      end
    end

    context "when two or more members in a household" do
      it "returns false" do
        application = create(:common_application, :multi_member)

        skip_step = Integrated::DependentCareExpensesController.skip?(application)
        expect(skip_step).to be_falsey
      end
    end
  end

  describe "#update" do
    context "when disability_care is true" do
      let(:valid_params) do
        {
          disability_care: "true",
        }
      end

      it "adds disability_care as an expense" do
        current_app = create(:common_application)
        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        current_app.reload
        expense_types = current_app.expenses.map(&:expense_type)

        expect(expense_types).to match_array(["disability_care"])
      end

      context "when disability_care expense already exists" do
        it "does not create an additional expense" do
          current_app = create(:common_application,
            expenses: [build(:expense, expense_type: "disability_care")])

          session[:current_application_id] = current_app.id

          put :update, params: { form: valid_params }

          current_app.reload
          expense_types = current_app.expenses.map(&:expense_type)

          expect(expense_types).to match_array(["disability_care"])
        end
      end
    end

    context "when disability_care is false" do
      let(:valid_params) do
        {
          disability_care: "false",
        }
      end

      it "removes disability_care as an expense" do
        current_app = create(:common_application,
          expenses: [build(:expense, expense_type: "disability_care")])

        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        current_app.reload
        expense_types = current_app.expenses.map(&:expense_type)

        expect(expense_types).to match_array([])
      end
    end
  end
end
