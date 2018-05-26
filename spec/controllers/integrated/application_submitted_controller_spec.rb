require "rails_helper"

RSpec.describe Integrated::ApplicationSubmittedController do
  describe "#edit" do
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
    end

    context "without a current application" do
      it "redirects to first step path without sending email" do
        get :edit

        expect(response).to redirect_to(controller.first_step_path)
        expect(Integrated::ExportFactory).to_not have_received(:create)
      end
    end
  end

  describe "#update" do
    context "email entered" do
      it "updates attributes" do
        current_app = create(:common_application, email: "test@example.com")
        session[:current_application_id] = current_app.id

        valid_params = { email: "new_email@example.com" }

        expect do
          put :update, params: { form: valid_params }
        end.to change {
          current_app.reload.email
        }.from("test@example.com").to("new_email@example.com")
      end

      it "enqueues an export of the application via email" do
        current_app = create(:common_application)
        session[:current_application_id] = current_app.id

        allow(Integrated::ExportFactory).to receive(:create)

        valid_params = { email: "new_email@example.com" }

        put :update, params: { form: valid_params }

        expect(Integrated::ExportFactory).to have_received(:create).
          with(benefit_application: current_app, destination: :client_email)
      end
    end

    context "email not entered" do
      it "re-renders the edit template" do
        current_app = create(:common_application)
        session[:current_application_id] = current_app.id

        valid_params = { email: "" }

        put :update, params: { form: valid_params }

        expect(assigns(:form)).to be_an_instance_of(ApplicationSubmittedForm)
        expect(response).to render_template(:edit)
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
