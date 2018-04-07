require "rails_helper"

RSpec.describe Integrated::HasYourIncomeChangedController do
  describe "#update" do
    context "with valid params" do
      let(:valid_params) do
        { income_changed: "yes" }
      end

      it "updates the model" do
        current_app = create(:common_application)
        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        current_app.reload

        expect(current_app.income_changed_yes?).to be_truthy
      end
    end
  end
end
