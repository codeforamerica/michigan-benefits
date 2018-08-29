require "rails_helper"

RSpec.describe SuccessController do
  before do
    session[:snap_application_id] = current_app.id
  end

  let(:attributes) { { email: "test@example.com" } }
  let(:current_app) { create(:snap_application, attributes: attributes) }

  describe "#edit" do
    it "assigns the attributes to the step" do
      get :edit

      expect(assigns(:step).email).to eq "test@example.com"
    end

    it "emails the snap application to the office" do
      allow(ExportFactory).to receive(:create)

      get :edit

      expect(ExportFactory).to have_received(:create).
        with(benefit_application: current_app, destination: :office_email)
    end

    context "sms consent present" do
      it "sends the submitted_message sms" do
        run_background_jobs_immediately do
          with_modified_env TWILIO_PHONE_NUMBER: "8005551212" do
            current_app.update(
              sms_consented: true,
              phone_number: "8001112222",
            )

            get :edit

            expect(FakeTwilioClient.messages.count).to eq 1
          end
        end
      end

      context "multiple visits" do
        it "only sends sms once" do
          run_background_jobs_immediately do
            with_modified_env TWILIO_PHONE_NUMBER: "8005551212" do
              current_app.update(
                sms_consented: true,
                phone_number: "8001112222",
              )

              get :edit
              get :edit

              expect(FakeTwilioClient.messages.count).to eq 1
            end
          end
        end
      end
    end

    context "no sms consent present" do
      it "does not send an SMS" do
        run_background_jobs_immediately do
          with_modified_env TWILIO_PHONE_NUMBER: "8005551212" do
            current_app.update(
              sms_consented: false,
              phone_number: "8001112222",
            )

            get :edit

            expect(FakeTwilioClient.messages.count).to eq 0
          end
        end
      end
    end
  end

  context "in order to not allow going back" do
    describe "#previous_path" do
      it "returns nil" do
        expect(subject.previous_path).to be_nil
      end
    end
  end

  describe "#update" do
    context "no office location" do
      it "redirects to the home page" do
        params = { step: attributes }

        put :update, params: params

        expect(response).to redirect_to(root_path(anchor: "fold"))
      end
    end

    context "office location present" do
      it "redirects to the office specific landing page" do
        current_app.update(office_page: "union")
        params = { step: attributes }

        put :update, params: params

        expect(response).to redirect_to(union_path(anchor: "fold"))
      end
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

      it "Enqueues an export of the snap application via email" do
        allow(ExportFactory).to receive(:create)

        params = { step: { email: "new_email@example.com" } }

        put :update, params: params

        expect(ExportFactory).to have_received(:create).
          with(benefit_application: current_app, destination: :client_email)
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
end
