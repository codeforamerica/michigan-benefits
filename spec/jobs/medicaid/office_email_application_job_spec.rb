require "rails_helper"

RSpec.describe Medicaid::OfficeEmailApplicationJob do
  describe "#perform" do
    it "sends an email" do
      tempfile = double("tempfile")
      medicaid_application = double("medicaid_application",
        id: 1,
        receiving_office_email: "official@stable.gov",
        primary_member: double("member", display_name: "Henry Horse"),
        pdf: tempfile)
      export = double("export")

      allow(export).to receive(:execute).and_yield(
        medicaid_application, double("logger").as_null_object
      )

      fake_message = double("message", deliver: nil)
      expect(ApplicationMailer).to receive(:office_medicaid_application_notification).
        with(recipient_email: "official@stable.gov",
             applicant_name: "Henry Horse",
             application_pdf: tempfile) { fake_message }

      expect(fake_message).to receive(:deliver)

      Medicaid::OfficeEmailApplicationJob.new.perform(export: export)
    end
  end
end
