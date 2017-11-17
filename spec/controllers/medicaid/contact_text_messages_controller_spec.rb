require "rails_helper"

RSpec.describe Medicaid::ContactTextMessagesController do
  include_examples "application required"

  describe "#edit" do
    context "phone number present, sms phone number nil" do
      it "defaults sms phone number to phone number" do
        phone_number = "2223334444"
        current_app.update(
          phone_number: phone_number,
          sms_phone_number: nil,
        )
        session[:medicaid_application_id] = current_app.id

        get :edit

        step = assigns(:step)
        expect(step.sms_phone_number).to eq phone_number
      end
    end

    context "phone number present, sms phone number blank" do
      it "defaults sms phone number to blank" do
        phone_number = "2223334444"
        current_app.update(
          phone_number: phone_number,
          sms_phone_number: "",
        )
        session[:medicaid_application_id] = current_app.id

        get :edit

        step = assigns(:step)
        expect(step.sms_phone_number).to eq ""
      end
    end

    context "phone number present, sms phone number present" do
      it "defaults sms phone number to sms phone number" do
        phone_number = "2223334444"
        sms_phone_number = "4443332222"
        current_app.update(
          phone_number: phone_number,
          sms_phone_number: sms_phone_number,
        )
        session[:medicaid_application_id] = current_app.id

        get :edit

        step = assigns(:step)
        expect(step.sms_phone_number).to eq sms_phone_number
      end
    end
  end

  def current_app
    @_current_app ||= create(:medicaid_application)
  end
end
