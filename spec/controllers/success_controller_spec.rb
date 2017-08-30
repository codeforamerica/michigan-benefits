# frozen_string_literal: true

require "rails_helper"

RSpec.describe SuccessController do
  before do
    session[:snap_application_id] = current_app.id
  end

  describe "#edit" do
    it "assigns the attributes to the step" do
      get :edit

      expect(step.email).to eq "test@example.com"
    end
  end

  context "in order to not allow going back" do
    describe "#previous_path" do
      it "returns nil" do
        expect(subject.previous_path).to eq nil
      end
    end
  end

  describe "#update" do
    it "redirects" do
      params = { step: attributes }

      put :update, params: params

      expect(response).to redirect_to(root_path(anchor: "fold"))
    end

    context "email entered" do
      it "updates attributes" do
        params = { step: { email: "new_email@example.com" } }

        expect do
          put :update, params: params
        end.to change {
          current_app.reload.email
        }.from("test@example.com").to("new_email@example.com")
      end

      it "creates a EmailApplicationJob" do
        allow(EmailApplicationJob).to receive(:perform_later)

        params = { step: { email: "new_email@example.com" } }

        put :update, params: params

        expect(EmailApplicationJob).to have_received(:perform_later).
          with(snap_application_id: current_app.id)
      end
    end

    context "email not entered" do
      it "renders the edit template" do
        params = { step: { email: "" } }

        put :update, params: params

        expect(assigns(:step)).to be_an_instance_of(Success)
        expect(response).to render_template(:edit)
      end
    end
  end

  def step
    @_step ||= assigns(:step)
  end

  def attributes
    { email: "test@example.com" }
  end

  def current_app
    @_current_app ||= create(:snap_application, attributes)
  end
end
