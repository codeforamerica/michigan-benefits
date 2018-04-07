require "rails_helper"

RSpec.describe Integrated::TellUsIncomeChangedController do
  describe "#skip?" do
    context "there is no recent income change" do
      it "returns true" do
        application = create(:common_application, income_changed: "no")

        skip_step = Integrated::TellUsIncomeChangedController.skip?(application)
        expect(skip_step).to eq(true)
      end
    end
  end

  describe "#update" do
    context "with valid params" do
      let(:valid_params) do
        { income_changed_explanation: "I lost my job." }
      end

      it "updates the model" do
        current_app = create(:common_application)
        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        current_app.reload

        expect(current_app.income_changed_explanation).to eq("I lost my job.")
      end
    end
  end
end
