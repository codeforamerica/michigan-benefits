# frozen_string_literal: true

require "rails_helper"

RSpec.describe PreferencesRemindersConfirmationController, :member, type: :controller do
  let(:params) do
    {
      email: "bob@example.com",
    }
  end

  let!(:current_app) do
    App.create!(params.merge(user: member, email_reminders: true))
  end

  let(:step) { assigns(:step) }

  describe "#edit" do
    it "assigns the fields to the step" do
      get :edit

      expect(step.email).to eq("bob@example.com")
    end

    it "skips when no reminders are wanted" do
      current_app.update!(email_reminders: false)
      get :edit
      expect(response).to redirect_to(step_path(PreferencesForInterviewController))
    end
  end

  describe "#update" do
    context "when valid" do
      let(:valid_params) do
        {
          email: "alice@example.com",
        }
      end

      it "updates the app" do
        expect do
          put :update, params: { step: valid_params }
        end.to change { current_app.reload.email }
      end

      it "redirects to the next step" do
        put :update, params: { step: valid_params }

        expect(response).to redirect_to(step_path(PreferencesForInterviewController))
      end
    end

    describe "when not valid" do
      it "renders :edit" do
        put :update, params: {}
        expect(response).to render_template(:edit)
      end

      it "sets the step" do
        put :update, params: {}
        expect(step).to be_an_instance_of(described_class.step_class)
      end
    end
  end
end
