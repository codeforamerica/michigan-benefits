require "rails_helper"

RSpec.describe Integrated::PhoneNumberController do
  describe "#update" do
    context "with valid params" do
      let(:valid_params) do
        { phone_number: "2024561111" }
      end

      it "updates the models" do
        current_app = create(:common_application)
        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        current_app.reload

        expect(current_app.phone_number).to eq("2024561111")
      end
    end
  end
end
