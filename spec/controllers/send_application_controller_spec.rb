# frozen_string_literal: true

require "rails_helper"

RSpec.describe SendApplicationController do
  before do
    session[:snap_application_id] = current_app.id
  end

  describe "#edit" do
    it "assigns the attributes to the step" do
      get :edit

      expect(step.email).to eq "test@example.com"
    end
  end

  describe "#update" do
    it "redirects" do
      params = { step: attributes }

      put :update, params: params

      expect(response).to redirect_to(root_path(anchor: "fold"))
    end

    it "creates a PDF with the data" do
      pdf_double = double(delay: true)
      job_double = double(save: true)
      allow(pdf_double).to receive(:delay).and_return(job_double)
      allow(Dhs1171Pdf).to receive(:new).with(current_app).and_return(pdf_double)

      put :update, params: { step: { email: "new_email@example.com" } }

      expect(pdf_double).to have_received(:delay)
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
    end

    context "email not entered" do
      it "renders the edit template" do
        params = { step: { email: "" } }

        put :update, params: params

        expect(assigns(:step)).to be_an_instance_of(SendApplication)
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
    @_current_app ||= FactoryGirl.create(:snap_application, attributes)
  end
end
