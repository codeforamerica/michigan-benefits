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
      expect(step.email_subscribed).to eq true
    end
  end

  describe "#update" do
    context "when valid" do
      it "updates the current app and redirects to the next step" do
        valid_params = {
          sms_subscribed: "t",
          email_subscribed: "f",
        }

        put :update, params: { step: valid_params }

        expect(current_app.reload.sms_subscribed).to eq true
        expect(current_app.reload.email_subscribed).to eq false
        expect(response).to redirect_to("/steps/general-anything-else")
      end
    end
  end

  def current_app
    @_current_app ||= create(
      :snap_application,
      sms_subscribed: false,
      email_subscribed: true,
    )
  end
end
