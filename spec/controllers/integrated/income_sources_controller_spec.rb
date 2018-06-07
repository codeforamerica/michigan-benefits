require "rails_helper"

RSpec.describe Integrated::IncomeSourcesController do
  describe "#edit" do
    it "assigns existing income sources" do
      primary_member = build(:household_member,
        additional_incomes: [build(:additional_income, income_type: "unemployment")])
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
        income_types = current_app.members[1].additional_incomes.map(&:income_type)

        expect(income_types).to match_array(["unemployment", "pension"])
      end

      it "destroys incomes from params" do
        primary_member = build(:household_member, additional_incomes: [
                                 build(:additional_income, income_type: "ssi"),
                               ])
        current_app = create(:common_application, members: [primary_member])
        session[:current_application_id] = current_app.id

        put :update, params: {
          form: valid_params.merge!(id: primary_member.id),
        }

        primary_member.reload
        income_types = primary_member.additional_incomes.map(&:income_type)

        expect(income_types).to match_array(["unemployment", "pension"])
      end
    end
  end

  describe "#income_sources" do
    context "applying for food assistance" do
      it "should include taxable income sources" do
        current_app = create(:common_application, :multi_member_food)
        session[:current_application_id] = current_app.id

        expect(controller.income_sources.keys).to include(:ssi, :child_support, :workers_comp)
      end
    end

    context "applying for health coverage only" do
      it "should not include any taxable income sources" do
        current_app = create(:common_application, :multi_member_healthcare)
        session[:current_application_id] = current_app.id

        expect(controller.income_sources.keys).to_not include(:ssi, :child_support, :workers_comp)
      end
    end
  end
end
