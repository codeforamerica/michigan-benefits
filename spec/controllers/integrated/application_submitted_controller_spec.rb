require "rails_helper"

RSpec.describe Integrated::ApplicationSubmittedController do
  describe "edit" do
    before do
      allow(Integrated::ExportFactory).to receive(:create)
    end

    context "with a current application" do
      it "queues an email with the application" do
        current_app = create(:common_application)
        session[:current_application_id] = current_app.id

        get :edit

        expect(Integrated::ExportFactory).to have_received(:create).
          with(destination: :office_email, benefit_application: current_app)
      end

      it "clears current application from session" do
        current_app = create(:common_application)
        session[:current_application_id] = current_app.id

        get :edit

        expect(session[:current_application_id]).to be_nil
      end
    end

    context "without a current application" do
      it "redirects to first step path without sending email" do
        get :edit

        expect(response).to redirect_to(controller.first_step_path)
        expect(Integrated::ExportFactory).to_not have_received(:create)
      end
    end
  end

  describe ".previous_path" do
    it "returns nil" do
      expect(controller.previous_path("foo")).to be_nil
    end
  end

  describe ".next_path" do
    it "returns the first step path" do
      expect(controller.next_path).to eq(controller.first_step_path)
    end
  end
end
