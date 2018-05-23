require "rails_helper"

RSpec.describe Integrated::YourExpensesDetailsController do
  describe "#skip?" do
    context "when applicant any court ordered or other expenses" do
      it "returns false" do
        application = create(:common_application, :single_member,
          expenses: [build(:expense, expense_type: "student_loan_interest")])

        skip_step = Integrated::YourExpensesDetailsController.skip?(application)
        expect(skip_step).to eq(false)
      end
    end

    context "when applicant no court ordered or other expenses" do
      it "returns true" do
        application = create(:common_application, :single_member,
          expenses: [build(:expense, expense_type: "health_insurance")])

        skip_step = Integrated::YourExpensesDetailsController.skip?(application)
        expect(skip_step).to eq(true)
      end
    end

    context "when application has multiple household members" do
      it "returns true" do
        application = create(:common_application, :multi_member,
          expenses: [build(:expense, expense_type: "student_loan_interest")])

        skip_step = Integrated::YourExpensesDetailsController.skip?(application)
        expect(skip_step).to eq(true)
      end
    end
  end

  describe "edit" do
    context "with existing expense details" do
      it "assigns previously entered details" do
        application = create(:common_application, :single_member,
          expenses: [
            build(:expense, expense_type: "health_insurance", amount: 120),
            build(:expense, expense_type: "alimony", amount: 150),
            build(:expense, expense_type: "student_loan_interest", amount: 17),
          ])

        session[:current_application_id] = application.id

        get :edit

        form = assigns(:form)

        expect(form.expenses.count).to eq(2)
        expect(form.expenses.first.amount).to eq(150)
        expect(form.expenses.second.amount).to eq(17)
      end
    end
  end

  describe "#update" do
    let(:expenses) do
      [
        build(:expense, expense_type: "alimony"),
        build(:expense, expense_type: "child_support"),
      ]
    end

    let(:application) do
      create(:common_application, :single_member, expenses: expenses)
    end

    context "with valid params" do
      let(:valid_params) do
        {
          expenses: {
            expenses.first.id => {
              amount: 100,
            },
            expenses.second.id => {
              amount: nil,
            },
          },
        }
      end

      it "updates the models" do
        session[:current_application_id] = application.id

        put :update, params: { form: valid_params }

        expect(Expense.find(expenses.first.id).amount).to eq(100)
        expect(Expense.find(expenses.second.id).amount).to eq(nil)
      end
    end

    context "with invalid params" do
      let(:invalid_params) do
        {
          expenses: {
            expenses.first.id => {
              amount: "one hundred",
            },
            expenses.second.id => {
              amount: 50,
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
