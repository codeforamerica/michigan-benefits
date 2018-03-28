require "rails_helper"

RSpec.describe Integrated::AnyoneCaretakerController do
  describe "#skip?" do
    context "when single member household" do
      it "returns true" do
        application = create(:common_application, :single_member)

        skip_step = Integrated::AnyoneCaretakerController.skip?(application)
        expect(skip_step).to be_truthy
      end
    end

    context "when multi member household" do
      it "returns false" do
        application = create(:common_application, :multi_member)

        skip_step = Integrated::AnyoneCaretakerController.skip?(application)
        expect(skip_step).to be_falsey
      end
    end
  end

  describe "#update" do
    context "with valid params" do
      let(:valid_params) do
        {
          anyone_caretaker: "true",
        }
      end

      it "updates the application navigator" do
        current_app = create(:common_application,
          :multi_member,
          navigator: build(:application_navigator, anyone_caretaker: false))
        session[:current_application_id] = current_app.id

        expect do
          put :update, params: { form: valid_params }
        end.to change {
          current_app.reload
          current_app.navigator.anyone_caretaker?
        }.to eq(true)
      end
    end
  end
end
