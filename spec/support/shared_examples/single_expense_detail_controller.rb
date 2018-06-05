require "rails_helper"

RSpec.shared_examples_for "single expense detail controller" do |expense_type, other_expense_type, attrs|
  let(:member_attributes) do
    attrs || {}
  end

  describe "#skip?" do
    context "with a single member household and relevant expenses" do
      it "returns true" do
        application = create(:common_application,
          members: [build(:household_member, **member_attributes)],
          expenses: [build(:expense, expense_type: expense_type)])
        skip_step = controller.class.skip?(application)
        expect(skip_step).to eq(true)
      end
    end

    context "with a multimember household" do
      context "has relevant expenses" do
        it "returns false" do
          application = create(:common_application,
            members: build_list(:household_member, 2, **member_attributes),
            expenses: [build(:expense, expense_type: expense_type)])

          skip_step = controller.class.skip?(application)
          expect(skip_step).to eq(false)
        end
      end

      context "has no relevant expenses" do
        it "returns true" do
          application = create(:common_application,
            members: build_list(:household_member, 2, **member_attributes),
            expenses: [build(:expense, expense_type: other_expense_type)])

          skip_step = controller.class.skip?(application)
          expect(skip_step).to eq(true)
        end
      end
    end
  end

  describe "edit" do
    context "with existing expense details" do
      it "assigns previously entered details" do
        members = build_list(:household_member, 4, **member_attributes)
        application = create(:common_application,
          members: members,
          expenses: [build(:expense,
            expense_type: expense_type,
            amount: 100,
            members: [members[0], members[1]])])
        session[:current_application_id] = application.id

        get :edit

        form = assigns(:form)

        expect(form.amount).to eq(100)
        expect(form.member_ids).to match_array([members[0].id, members[1].id])
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "#update" do
    context "with valid params" do
      let(:member1) do
        build(:household_member)
      end

      let(:member2) do
        build(:household_member)
      end

      let(:valid_params) do
        {
          amount: "100",
          member_ids: [member1.id.to_s, member2.id.to_s],
        }
      end

      it "updates the models" do
        current_app = create(:common_application,
          expenses: [build(:expense, expense_type: expense_type)],
          members: [member1, member2] + build_list(:household_member, 2))

        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        expense = current_app.expenses.find_by(expense_type: expense_type)

        expect(expense.amount).to eq(100)
        expect(expense.members).to match_array([member1, member2])
      end

      context "with existing member relationships" do
        it "overwrites the member relationships for the given expense" do
          member3 = build(:household_member)
          current_app = create(:common_application,
            expenses: [build(:expense, expense_type: expense_type, members: [member2, member3])],
            members: [member1, member2, member3])

          session[:current_application_id] = current_app.id

          put :update, params: { form: valid_params }

          expense = current_app.expenses.find_by(expense_type: expense_type)

          expect(expense.members).to match_array([member1, member2])
        end
      end
    end

    context "with invalid params" do
      let(:invalid_params) do
        {}
      end

      it "renders edit without updating" do
        current_app = create(:common_application)
        session[:current_application_id] = current_app.id

        put :update, params: { form: invalid_params }

        expect(response).to render_template(:edit)
      end
    end
  end
end
