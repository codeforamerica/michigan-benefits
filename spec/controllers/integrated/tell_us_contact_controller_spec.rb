require "rails_helper"

RSpec.describe Integrated::TellUsContactController do
  describe "#skip?" do
    context "neither SMS nor email consent given" do
      it "returns true" do
        application = create(:common_application, sms_consented: "no", email_consented: "no")

        skip_step = Integrated::TellUsContactController.skip?(application)
        expect(skip_step).to eq(true)
      end
    end
  end

  describe "edit" do
    context "with a current application" do
      it "assigns existing attributes" do
        current_app = create(:common_application, email: "jessie@example.com")
        session[:current_application_id] = current_app.id

        get :edit

        form = assigns(:form)
        expect(form.email).to eq("jessie@example.com")
      end
    end
  end

  describe "#update" do
    context "with valid params" do
      let(:valid_params) do
        { email: "jessie@example.com", sms_phone_number: "2024561111" }
      end

      it "updates the models" do
        current_app = create(:common_application)
        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        current_app.reload

        expect(current_app.email).to eq("jessie@example.com")
        expect(current_app.sms_phone_number).to eq("2024561111")
      end
    end
  end
end
