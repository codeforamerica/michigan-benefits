require "rails_helper"

RSpec.describe ContactConfirmPhoneNumberController do
  let(:step) { assigns(:step) }
  let(:invalid_params) { { step: { phone_number: "" } } }
  let(:step_class) { ContactConfirmPhoneNumber }

  include_examples(
    "step controller",
    "param validation",
    "application required",
  )

  describe "#update" do
    it "updates the phone number" do
      session[:snap_application_id] = current_app.id
      new_phone_number = "4443332222"
      params = { step: { phone_number: new_phone_number } }

      put :update, params: params

      expect(current_app.reload.phone_number).to eq new_phone_number
    end
  end

  def current_app
    @_current_app ||= create(
      :snap_application,
      sms_consented: true,
      phone_number: "2223334444",
    )
  end
end
