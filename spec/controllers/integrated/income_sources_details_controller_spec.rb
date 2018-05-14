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
        member = create(:household_member, incomes: [build(:income, income_type: "unemployment")])
        application = create(:common_application, members: [member])

        skip_step = Integrated::IncomeSourcesDetailsController.skip?(application)
        expect(skip_step).to eq(false)
      end
    end
  end

  describe "edit" do
    context "with a current application" do
      xit "assigns existing attributes" do
        current_app = create(:common_application)
        session[:current_application_id] = current_app.id

        get :edit

        form = assigns(:form)

        # expectation
      end
    end

    context "without a current application" do
      it "renders edit" do
        get :edit

        expect(response).to render_template(:edit)
      end
    end
  end

  describe "#update" do
    context "with valid params" do
      let(:member) do
        create(:household_member, incomes: [income_1, income_2])
      end

      let(:income_1) do
        build(:income)
      end

      let(:income_2) do
        build(:income)
      end

      let(:valid_params) do
        {
          id: member.id,
          incomes: {
            income_1.id => {
              amount: "100.30"
            },
            income_2.id => {
              amount: ""
            }
          }
        }
      end

      it "updates the models" do
        current_app = create(:common_application, members: [member])
        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        member.reload

        first_income = member.incomes.find(income_1.id)
        second_income = member.incomes.find(income_2.id)

        expect(first_income.amount).to eq(100)
        expect(second_income.amount).to be_nil
      end
    end

    context "with invalid params" do
      let(:invalid_params) do
        { }
      end

      xit "renders edit without updating" do
        current_app = create(:common_application)
        session[:current_application_id] = current_app.id

        put :update, params: { form: invalid_params }

        expect(response).to render_template(:edit)
      end
    end
  end
end
