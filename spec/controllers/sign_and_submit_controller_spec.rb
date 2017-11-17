require "rails_helper"

RSpec.describe SignAndSubmitController do
  let(:step) { assigns(:step) }
  let(:invalid_params) { { step: { signature: "" } } }
  let(:step_class) { SignAndSubmit }

  before { session[:snap_application_id] = current_app.id }

  include_examples(
    "step controller",
    "param validation",
    "application required",
  )

  describe "#edit" do
    it "assigns the attributes to the step" do
      get :edit

      expect(attributes.keys.map { |attr| [attr, step.send(attr)] }.to_h).to eq(
        attributes,
      )
    end
  end

  describe "#update" do
    it "updates attributes" do
      params = { step: { signature: "Chiu Baka" } }

      expect do
        put :update, params: params
      end.to change {
        current_app.reload.signature
      }.from("Hans Solo").to("Chiu Baka")

      expect(current_app.signed_at).not_to be nil
    end

    it "redirects" do
      params = { step: { signature: "Chiu Baka" } }

      put :update, params: params

      expect(response).to redirect_to("/steps/document-guide")
    end
  end

  def current_app
    @_current_app ||= create(:snap_application, attributes)
  end

  def attributes
    { signature: "Hans Solo" }
  end
end
