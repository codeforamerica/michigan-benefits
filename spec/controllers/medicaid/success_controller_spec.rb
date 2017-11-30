require "rails_helper"

RSpec.describe Medicaid::SuccessController do
  before do
    session[:medicaid_application_id] = current_app.id
  end

  describe "#edit" do
    it "emails the medicaid application to the office" do
      allow(Medicaid::ExportFactory).to receive(:create)

      get :edit

      expect(Medicaid::ExportFactory).to have_received(:create).
        with(benefit_application: current_app, destination: :office_email)
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
    @_current_app ||= create(:medicaid_application)
  end
end
