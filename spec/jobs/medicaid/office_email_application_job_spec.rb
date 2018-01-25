require "rails_helper"

RSpec.describe Medicaid::OfficeEmailApplicationJob do
  describe "#perform" do
    it "sends an email" do
      tempfile = Tempfile.new
      medicaid_application = double("medicaid_application",
        id: 1,
        receiving_office_email: "official@stable.gov",
        primary_member: double("member", display_name: "Henry Horse"),
        pdf: tempfile)
      export = double("export")
      logger = double("logger").as_null_object

      allow(export).to receive(:execute).and_yield(medicaid_application, logger)

      fake_mailer = double("mailer", deliver: nil)
      allow(ApplicationMailer).to receive(:office_medicaid_application_notification).
        and_return(fake_mailer)

      Medicaid::OfficeEmailApplicationJob.new.perform(export: export)

      expect(ApplicationMailer).to have_received(:office_medicaid_application_notification).
        with(recipient_email: "official@stable.gov",
             applicant_name: "Henry Horse",
             application_pdf: tempfile)

      expect(fake_mailer).to have_received(:deliver)
    end
  end
end
