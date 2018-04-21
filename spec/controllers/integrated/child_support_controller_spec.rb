require "rails_helper"

RSpec.describe Integrated::ChildSupportController do
  describe "#skip?" do
    context "when applicant has stable housing" do
      xit "returns true" do
        application = create(:common_application, living_situation: "stable_address")

        skip_step = Integrated::ChildSupportController.skip?(application)
        expect(skip_step).to eq(true)
      end
    end
  end

  describe "#update" do
    context "when child_support is true" do
      let(:valid_params) do
        {
          child_support: "true",
        }
      end

      it "adds child_support as an expense" do
        current_app = create(:common_application)
        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        current_app.reload
        expense_types = current_app.expenses.map(&:expense_type)

        expect(expense_types).to match_array(["child_support"])
      end

      context "when child_support expense already exists" do
        it "does not create an additional expense" do
          current_app = create(:common_application,
            expenses: [build(:expense, expense_type: "child_support")])

          session[:current_application_id] = current_app.id

          put :update, params: { form: valid_params }

          current_app.reload
          expense_types = current_app.expenses.map(&:expense_type)

          expect(expense_types).to match_array(["child_support"])
        end
      end
    end

    context "when child_support is false" do
      let(:valid_params) do
        {
          child_support: "false",
        }
      end

      it "removes child_support as an expense" do
        current_app = create(:common_application,
          expenses: [build(:expense, expense_type: "child_support")])

        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        current_app.reload
        expense_types = current_app.expenses.map(&:expense_type)

        expect(expense_types).to match_array([])
      end
    end
  end
end
