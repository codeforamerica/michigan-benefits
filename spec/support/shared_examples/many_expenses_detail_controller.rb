require "rails_helper"

RSpec.shared_examples_for "many expenses details controller" do |expense_type, other_expense_type|
  describe "#skip?" do
    context "with a multimember household" do
      it "returns true" do
        application = create(:common_application,
          :multi_member,
          expenses: [build(:expense, expense_type: expense_type)])

        skip_step = controller.class.skip?(application)
        expect(skip_step).to eq(true)
      end
    end

    context "with a single member household" do
      context "has relevant expenses" do
        it "returns false" do
          application = create(:common_application,
            :single_member,
            expenses: [build(:expense, expense_type: expense_type)])

          skip_step = controller.class.skip?(application)
          expect(skip_step).to eq(false)
        end
      end

      context "has no relevant expenses" do
        it "returns true" do
          application = create(:common_application,
            :single_member,
            expenses: [build(:expense, expense_type: other_expense_type)])

          skip_step = controller.class.skip?(application)
          expect(skip_step).to eq(true)
        end
      end
    end
  end

  describe "#edit" do
    context "with existing expense amounts" do
      it "assigns previously entered details" do
        application = create(:common_application, :single_member,
          expenses: [
            build(:expense, expense_type: other_expense_type, amount: 120),
            build(:expense, expense_type: expense_type, amount: 150),
          ])

        session[:current_application_id] = application.id

        get :edit

        form = assigns(:form)

        expect(form.expenses.count).to eq(1)
        expect(form.expenses.first.amount).to eq(150)
      end
    end
  end

  describe "#update" do
    let(:relevant_expense) do
      build(:expense, expense_type: expense_type)
    end

    let(:irrelevant_expense) do
      build(:expense, expense_type: other_expense_type, amount: nil)
    end

    let(:application) do
      create(:common_application, :single_member, expenses: [relevant_expense, irrelevant_expense])
    end

    context "with valid params" do
      let(:valid_params) do
        {
          expenses: {
            relevant_expense.id => {
              amount: 100,
            },
            irrelevant_expense.id => {
              amount: 100,
            },
          },
        }
      end

      it "updates the relevant expenses" do
        session[:current_application_id] = application.id

        put :update, params: { form: valid_params }

        relevant_expense.reload
        irrelevant_expense.reload

        expect(relevant_expense.amount).to eq(100)
        expect(irrelevant_expense.amount).to eq(nil)
      end

      it "assigns the expense to the primary member" do
        relevant_expense.members << application.primary_member

        session[:current_application_id] = application.id

        put :update, params: { form: valid_params }

        relevant_expense.reload

        expect(relevant_expense.members).to match_array([application.primary_member])
      end
    end

    context "with invalid params" do
      let(:invalid_params) do
        {
          expenses: {
            relevant_expense.id => {
              amount: "one hundred",
            },
          },
        }
      end

      it "renders edit without updating" do
        session[:current_application_id] = application.id

        put :update, params: { form: invalid_params }

        expect(response).to render_template(:edit)
      end
    end
  end
end
