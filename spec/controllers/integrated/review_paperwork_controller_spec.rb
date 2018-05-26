require "rails_helper"

RSpec.describe Integrated::ReviewPaperworkController, type: :controller do
  describe "#skip?" do
    it "returns false" do
      application = create(:common_application)

      skip_step = Integrated::ReviewPaperworkController.skip?(application)
      expect(skip_step).to eq(false)
    end
  end

  describe "#update" do
    context "with valid params" do
      let(:valid_params) do
        {
          upload_paperwork: "true",
        }
      end

      it "updates the models" do
        current_app = create(:common_application,
          navigator: build(:application_navigator, upload_paperwork: false))

        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        current_app.reload

        expect(current_app.navigator.upload_paperwork).to be_truthy
      end
    end
  end
end
