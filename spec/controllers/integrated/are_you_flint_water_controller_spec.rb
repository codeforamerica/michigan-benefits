require "rails_helper"

RSpec.describe Integrated::AreYouFlintWaterController do
  describe "#skip?" do
    context "when household has one member" do
      context "when member is pregnant" do
        it "returns false" do
          application = create(:common_application,
                               members: build_list(:household_member, 1, pregnant: "yes"))
          skip_step = Integrated::AreYouFlintWaterController.skip?(application)
          expect(skip_step).to be_falsey
        end
      end

      context "when member has pregnancy expenses" do
        it "returns false" do
          application = create(:common_application,
                               members: build_list(:household_member, 1, pregnancy_expenses: "yes"))
          skip_step = Integrated::AreYouFlintWaterController.skip?(application)
          expect(skip_step).to be_falsey
        end
      end

      context "when member age is not set" do
        it "returns false" do
          application = create(:common_application,
                               members: build_list(:household_member, 1))
          skip_step = Integrated::AreYouFlintWaterController.skip?(application)
          expect(skip_step).to be_falsey
        end
      end

      context "when member is younger than 21" do
        it "returns false" do
          application = create(:common_application,
                               members: build_list(:household_member, 1, birthday: 20.years.ago))
          skip_step = Integrated::AreYouFlintWaterController.skip?(application)
          expect(skip_step).to be_falsey
        end
      end

      context "when member is 21 or older" do
        it "returns true" do
          application = create(:common_application, members: build_list(:household_member, 1, birthday: 22.years.ago))

          skip_step = Integrated::AreYouFlintWaterController.skip?(application)
          expect(skip_step).to be_truthy
        end
      end
    end

    context "when household has more than one member" do
      it "returns true" do
        application = create(:common_application, members: build_list(:household_member, 2))

        skip_step = Integrated::AreYouFlintWaterController.skip?(application)
        expect(skip_step).to be_truthy
      end
    end
  end

  describe "#update" do
    context "with valid params" do
      let(:valid_params) do
        {
          flint_water: "yes",
        }
      end

      it "updates the model" do
        current_app = create(:common_application, :single_member)
        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        current_app.reload

        expect(current_app.primary_member.flint_water_yes?).to be_truthy
      end
    end
  end
end
