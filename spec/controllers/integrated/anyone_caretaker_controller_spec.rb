require "rails_helper"

RSpec.describe Integrated::AnyoneCaretakerController do
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
