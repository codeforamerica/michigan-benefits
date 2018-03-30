require "rails_helper"

RSpec.describe Integrated::ImmigrationInfoController do
  describe "#skip?" do
    context "when everyone is a citizen" do
      it "returns true" do
        application = create(:common_application,
                             navigator: build(:application_navigator, everyone_citizen: true))

        skip_step = Integrated::ImmigrationInfoController.skip?(application)
        expect(skip_step).to eq(true)
      end
    end

    context "when not everyone is a citizen" do
      it "returns false" do
        application = create(:common_application,
                             navigator: build(:application_navigator, everyone_citizen: false))

        skip_step = Integrated::ImmigrationInfoController.skip?(application)
        expect(skip_step).to eq(false)
      end
    end
  end

  describe "#update" do
    context "with valid params" do
      let(:valid_params) do
        {
          immigration_info: "true",
        }
      end

      it "updates the application navigator" do
        current_app = create(:common_application,
                             :multi_member,
                             navigator: build(:application_navigator, immigration_info: false))
        session[:current_application_id] = current_app.id

        expect do
          put :update, params: { form: valid_params }
        end.to change {
          current_app.reload
          current_app.navigator.immigration_info?
        }.to eq(true)
      end
    end
  end
end
