require "rails_helper"

RSpec.describe Integrated::IncomeSourcesDetailsController do
  describe "#skip?" do
    context "no applicants have additional income sources" do
      it "returns true" do
        application = create(:common_application)
        skip_step = Integrated::IncomeSourcesDetailsController.skip?(application)
        expect(skip_step).to eq(true)
      end
    end

    context "one applicant has an additional income source" do
      it "returns false" do
        member = create(:household_member, additional_incomes: [build(:additional_income, income_type: "unemployment")])
        application = create(:common_application, members: [member])

        skip_step = Integrated::IncomeSourcesDetailsController.skip?(application)
        expect(skip_step).to eq(false)
      end
    end
  end

  describe "edit" do
    context "when primary member has an additional income source" do
      it "assigns primary member's additional income sources" do
        primary_member = build(:household_member, additional_incomes: build_list(:additional_income, 2))
        secondary_member = build(:household_member, additional_incomes: [])
        current_app = create(:common_application, members: [primary_member, secondary_member])
        session[:current_application_id] = current_app.id

        get :edit

        form = assigns(:form)

        expect(form.additional_incomes.count).to eq(2)
        expect(form.id).to eq(primary_member.id)
      end
    end

    context "when primary member does not have an additional income source" do
      it "assigns the next member's additional income source" do
        primary_member = build(:household_member, additional_incomes: [])
        secondary_member = build(:household_member, additional_incomes: build_list(:additional_income, 2))
        current_app = create(:common_application, members: [primary_member, secondary_member])
        session[:current_application_id] = current_app.id

        get :edit

        form = assigns(:form)

        expect(form.additional_incomes.count).to eq(2)
        expect(form.id).to eq(secondary_member.id)
      end
    end
  end

  describe "#update" do
    let(:member) do
      create(:household_member, additional_incomes: [income_1, income_2])
    end

    let(:income_1) do
      build(:additional_income)
    end

    let(:income_2) do
      build(:additional_income)
    end

    context "with valid params" do
      let(:valid_params) do
        {
          id: member.id,
          additional_incomes: {
            income_1.id => {
              amount: "100.30",
            },
            income_2.id => {
              amount: "",
            },
          },
        }
      end

      it "updates the models" do
        current_app = create(:common_application, members: [member])
        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        member.reload

        first_income = member.additional_incomes.find(income_1.id)
        second_income = member.additional_incomes.find(income_2.id)

        expect(first_income.amount).to eq(100)
        expect(second_income.amount).to be_nil
      end
    end

    context "with invalid params" do
      let(:invalid_params) do
        {
          id: "no one",
          additional_incomes: {
            income_1.id => {
              amount: "",
            },
            income_2.id => {
              amount: "",
            },
          },
        }
      end

      it "renders edit without updating" do
        current_app = create(:common_application, members: [member])
        session[:current_application_id] = current_app.id

        put :update, params: { form: invalid_params }

        expect(response).to render_template(:edit)
      end
    end
  end
end
