# frozen_string_literal: true

require "rails_helper"

RSpec.describe PreferencesAnythingElseController, :member, type: :controller do
  let(:params) do
    {
      anything_else: "no",
    }
  end

  let!(:current_app) do
    App.create!(params.merge(user: member))
  end

  let(:step) { assigns(:step) }

  describe "#edit" do
    it "assigns the fields to the step" do
      get :edit
      expect(step.anything_else).to eq("no")
    end
  end

  describe "#update" do
    let(:valid_params) do
      { anything_else: "yes" }
    end

    it "updates the app" do
      expect do
        put :update, params: { step: valid_params }
      end.to(change { current_app.reload.anything_else })
    end

    it "redirects to the next step" do
      put :update, params: { step: valid_params }

      expect(response).to redirect_to(step_path(LegalAgreementController))
    end
  end
end
