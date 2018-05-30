require "rails_helper"

RSpec.describe Integrated::DoYouHaveMedicalBillsController do
  describe "#update" do
    context "with valid params" do
      let(:valid_params) do
        {
          medical_bills: "yes",
        }
      end

      it "updates the model" do
        current_app = create(:common_application, :single_member)
        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        current_app.reload

        expect(current_app.primary_member.medical_bills_yes?).to be_truthy
      end
    end
  end
end
