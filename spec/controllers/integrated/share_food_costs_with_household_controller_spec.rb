require "rails_helper"

RSpec.describe Integrated::ShareFoodCostsWithHouseholdController do
  describe "#skip?" do
    context "when applicant has unstable housing" do
      it "returns true" do
        application = create(:common_application, living_situation: "temporary_address")

        skip_step = Integrated::ShareFoodCostsWithHouseholdController.skip?(application)
        expect(skip_step).to be_truthy
      end
    end

    context "when applicant has stable housing" do
      context "when application has two or fewer members applying for SNAP" do
        it "returns true" do
          application = create(:common_application,
            living_situation: "stable_address",
            members: build_list(:household_member, 2, requesting_food: "yes") + [build(:household_member)])

          skip_step = Integrated::ShareFoodCostsWithHouseholdController.skip?(application)
          expect(skip_step).to be_truthy
        end
      end

      context "when application has three or more members applying for SNAP" do
        it "returns false" do
          application = create(:common_application,
            living_situation: "stable_address",
            members: build_list(:household_member, 3, requesting_food: "yes"))

          skip_step = Integrated::ShareFoodCostsWithHouseholdController.skip?(application)
          expect(skip_step).to be_falsey
        end
      end
    end
  end

  describe "edit" do
    it "assigns existing attributes" do
      current_app = create(:common_application,
        navigator: build(:application_navigator, all_share_food_costs: true))
      session[:current_application_id] = current_app.id

      get :edit

      form = assigns(:form)

      expect(form.all_share_food_costs).to eq(true)
    end
  end

  describe "#update" do
    context "when false passed" do
      let(:valid_params) do
        { form: { all_share_food_costs: "false" } }
      end

      it "updates the models" do
        current_app = create(:common_application, :single_member, :with_navigator)
        session[:current_application_id] = current_app.id

        put :update, params: valid_params

        current_app.navigator.reload

        expect(current_app.navigator.all_share_food_costs).to be_falsey
      end
    end

    context "when true passed" do
      let(:valid_params) do
        { form: { all_share_food_costs: "true" } }
      end

      it "updates the models" do
        current_app = create(
          :common_application,
          :with_navigator,
          members: build_list(:household_member, 3, requesting_food: "yes")
        )
        session[:current_application_id] = current_app.id

        put :update, params: valid_params

        current_app.navigator.reload

        expect(current_app.navigator.all_share_food_costs).to be_truthy
        current_app.food_applying_members.each do |member|
          expect(member.buy_and_prepare_food_together).to eq("yes")
        end
      end
    end
  end
end
