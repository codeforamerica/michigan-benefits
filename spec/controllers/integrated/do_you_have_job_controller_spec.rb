require "rails_helper"

RSpec.describe Integrated::DoYouHaveJobController do
  describe "#skip?" do
    context "when in a multi-member household" do
      it "returns true" do
        application = create(:common_application, :multi_member)

        skip_step = Integrated::DoYouHaveJobController.skip?(application)
        expect(skip_step).to eq(true)
      end
    end
  end

  describe "#update" do
    context "with valid params" do
      let(:valid_params) do
        { current_job: true }
      end

      it "updates the models" do
        current_app = create(:common_application)
        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        current_app.reload

        expect(current_app.navigator.current_job).to be_truthy
      end
    end
  end
end
