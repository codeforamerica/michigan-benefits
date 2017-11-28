require "rails_helper"

RSpec.describe Medicaid::SuccessController do
  before do
    session[:medicaid_application_id] = current_app.id
  end

  describe "#edit" do
    it "emails the medicaid application to the office" do
      allow(ExportFactory).to receive(:create)

      get :edit

      expect(ExportFactory).to have_received(:create).
        with(benefit_application: current_app, destination: :office_email)
    end

    context "application is not exportable" do
      it "does not run the export factory, or application driver" do
        run_background_jobs_immediately do
          allow(ExportFactory).to receive(:create)
          current_app.update(signature: nil)

          get :edit

          expect(ExportFactory).not_to have_received(:create)
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
  end

  def current_app
    @_current_app ||= create(:medicaid_application, signature: "Test sig")
  end
end
