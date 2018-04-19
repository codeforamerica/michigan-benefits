require "rails_helper"

RSpec.describe Integrated::IncomeSourcesController do
  describe "edit" do
    it "assigns existing income sources" do
      primary_member = build(:household_member,
        incomes: [build(:income, income_type: "unemployment")],
      )
      current_app = create(
        :common_application,
        members: [primary_member],
      )
      session[:current_application_id] = current_app.id

      get :edit

      expect(assigns[:form].pension).to be_falsey
      expect(assigns[:form].unemployment).to be_truthy
    end
  end

  describe "#update" do
    context "with valid params" do
      let(:valid_params) do
        {
          unemployment: "1",
          pension: "1",
          ssi: "0",
        }
      end

      it "creates incomes from params" do
        current_app = create(:common_application, :multi_member)
        session[:current_application_id] = current_app.id

        put :update, params: {
          form: valid_params.merge!(id: current_app.members[1].id),
        }

        current_app.reload
        income_types = current_app.members[1].incomes.map(&:income_type)

        expect(income_types).to match_array(["unemployment", "pension"])
      end

      it "destroys incomes from params" do
        primary_member = build(:household_member, incomes: [
                                 build(:income, income_type: "ssi"),
                               ])
        current_app = create(:common_application, members: [primary_member])
        session[:current_application_id] = current_app.id

        put :update, params: {
          form: valid_params.merge!(id: primary_member.id),
        }

        primary_member.reload
        income_types = primary_member.incomes.map(&:income_type)

        expect(income_types).to match_array(["unemployment", "pension"])
      end
    end
  end
end
