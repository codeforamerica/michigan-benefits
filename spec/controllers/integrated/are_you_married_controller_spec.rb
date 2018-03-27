require "rails_helper"

RSpec.describe Integrated::AreYouMarriedController do
  describe "#skip?" do
    context "when household has one member" do
      it "returns false" do
        application = create(:common_application, members: build_list(:household_member, 1))

        skip_step = Integrated::AreYouMarriedController.skip?(application)
        expect(skip_step).to be_falsey
      end
    end

    context "when household has more than one member" do
      it "returns true" do
        application = create(:common_application, members: build_list(:household_member, 2))

        skip_step = Integrated::AreYouMarriedController.skip?(application)
        expect(skip_step).to be_truthy
      end
    end
  end

  describe "#update" do
    context "with valid params" do
      let(:valid_params) do
        {
          married: "yes",
        }
      end

      it "updates the models" do
        current_app = create(:common_application, members: build_list(:household_member, 1))
        session[:current_application_id] = current_app.id

        expect do
          put :update, params: { form: valid_params }
        end.to change { current_app.primary_member.married_yes? }.to eq(true)
      end
    end
  end
end
