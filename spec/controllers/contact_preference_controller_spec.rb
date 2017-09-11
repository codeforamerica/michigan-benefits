require "rails_helper"

RSpec.describe ContactPreferenceController do
  let(:step) { assigns(:step) }
  let(:invalid_params) { { step: { blah: "" } } }
  let(:step_class) { ContactPreference }

  before { session[:snap_application_id] = current_app.id }

  include_examples "step controller", "param validation"

  describe "#edit" do
    it "assigns the fields to the step" do
      get :edit

      expect(step.sms_subscribed).to eq false
    end
  end

  describe "#update" do
    context "when valid" do
      it "updates the current app and redirects to the next step" do
        valid_params = { sms_subscribed: "true" }

        put :update, params: { step: valid_params }

        expect(current_app.reload.sms_subscribed).to eq true
        expect(response).to redirect_to("/steps/contact-confirm-phone-number")
      end
    end
  end

  def current_app
    @_current_app ||= create(:snap_application, sms_subscribed: false)
  end
end
