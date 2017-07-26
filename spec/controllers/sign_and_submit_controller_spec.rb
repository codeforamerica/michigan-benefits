# frozen_string_literal: true

require "rails_helper"

RSpec.describe SignAndSubmitController, :member, type: :controller do
  let!(:current_app) do
    SnapApplication.create!(attributes.merge(user: member))
  end

  let(:attributes) do
    { signature: "Hans Solo" }.with_indifferent_access
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
    let(:params) do
      { step: { signature: "Chiu Baka" } }
    end

    it "updates attributes" do
      expect do
        put :update, params: params
      end.to change {
        current_app.reload.attributes.slice(*attributes.keys)
      }.from("signature" => "Hans Solo").to("signature" => "Chiu Baka")
    end

    it "redirects" do
      put :update, params: params
      expect(response).to redirect_to root_path(anchor: "fold")
    end
  end
end
