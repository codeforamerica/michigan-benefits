# frozen_string_literal: true

require "rails_helper"

RSpec.describe SignAndSubmitController, :member, type: :controller do
  let!(:current_app) do
    App.create!(
      attributes.merge(
        user: member,
        accepts_text_messages: true,
        phone_number: "4158675309",
      ),
    )
  end

  let(:attributes) do
    {
      signature: "Hans Solo",
    }.with_indifferent_access
  end

  let(:step) do
    assigns(:step)
  end

  describe "#edit" do
    it "assigns the attributes to the step" do
      get :edit

      expect(attributes.keys.map { |attr| [attr, step.send(attr)] }.to_h).to eq attributes
    end
  end

  describe "#update" do
    around do |example|
      env = {
        TWILIO_PHONE_NUMBER: "8005551212",
        TWILIO_RECIPIENT_WHITELIST: "4158675309",
      }

      with_modified_env(env) do
        example.run
      end
    end

    let(:params) do
      {
        step: {
          signature: "Chiu Baka",
        },
      }
    end

    it "updates attributes" do
      expect do
        put :update, params: params
      end.to change {
        current_app.reload.attributes.slice(*attributes.keys)
      }.from("signature" => "Hans Solo").to("signature" => "Chiu Baka")
    end

    it "sends an sms" do
      put :update, params: params
      expect(FakeTwilioClient.messages.last.body).
        to include "Your application for Healthcare Coverage & Food Assistance was submitted!"
    end

    it "redirects" do
      put :update, params: params
      expect(response).to redirect_to step_path(MaybeSubmitDocumentsController)
    end
  end
end
