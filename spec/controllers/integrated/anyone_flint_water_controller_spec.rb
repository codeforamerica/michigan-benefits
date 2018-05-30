require "rails_helper"

RSpec.describe Integrated::AnyoneFlintWaterController do
  describe "#skip?" do
    context "when multi member household" do
      context "when a member is pregnant" do
        it "returns false" do
          application = create(:common_application,
            members: build_list(:household_member, 2, requesting_healthcare: "yes", pregnant: "yes"))
          skip_step = Integrated::AnyoneFlintWaterController.skip?(application)
          expect(skip_step).to be_falsey
        end
      end

      context "when a member has pregnancy expenses" do
        it "returns false" do
          application = create(:common_application,
            members: build_list(:household_member, 2, requesting_healthcare: "yes", pregnancy_expenses: "yes"))
          skip_step = Integrated::AnyoneFlintWaterController.skip?(application)
          expect(skip_step).to be_falsey
        end
      end

      context "when a member age is not set" do
        it "returns false" do
          application = create(:common_application,
                               members: build_list(:household_member, 2, requesting_healthcare: "yes"))
          skip_step = Integrated::AnyoneFlintWaterController.skip?(application)
          expect(skip_step).to be_falsey
        end
      end

      context "when a member is younger than 21" do
        it "returns false" do
          application = create(:common_application,
            members: build_list(:household_member, 2, requesting_healthcare: "yes", birthday: 20.years.ago))
          skip_step = Integrated::AnyoneFlintWaterController.skip?(application)
          expect(skip_step).to be_falsey
        end
      end

      context "when a member is 21 or older" do
        it "returns true" do
          application = create(:common_application,
            members: build_list(:household_member, 2, requesting_healthcare: "yes", birthday: 22.years.ago))

          skip_step = Integrated::AnyoneFlintWaterController.skip?(application)
          expect(skip_step).to be_truthy
        end
      end
    end
  end

  describe "#update" do
    context "when true" do
      let(:valid_params) do
        {
          anyone_flint_water: "true",
        }
      end

      it "updates the application navigator" do
        current_app = create(:common_application,
          :multi_member,
          navigator: build(:application_navigator, anyone_flint_water: false))

        session[:current_application_id] = current_app.id

        expect do
          put :update, params: { form: valid_params }
        end.to change {
          current_app.reload
          current_app.navigator.anyone_flint_water?
        }.to eq(true)
      end
    end

    context "when false" do
      let(:valid_params) do
        {
          anyone_flint_water: "false",
        }
      end

      it "updates the application navigator and household members" do
        current_app = create(:common_application,
          members: build_list(:household_member, 2, flint_water: "yes"),
          navigator: build(:application_navigator, anyone_flint_water: true))

        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        current_app.reload

        expect(current_app.navigator.anyone_flint_water?).to be_falsey
        expect(current_app.primary_member.flint_water_no?).to be_truthy
      end
    end
  end
end
