require "rails_helper"

RSpec.describe ClientEmailApplicationJob do
  describe "#perform" do
    it "creates a PDF with the snap application data" do
      tempfile = Tempfile.new
      snap_application = double("snap_application", email: "nowhere@example.horse", pdf: tempfile)
      export = double("export")
      logger = double("logger", info: "I have been logged")

      allow(export).to receive(:execute).and_yield(snap_application, logger)

      fake_mailer = double("mailer", deliver: nil)
      allow(ApplicationMailer).to receive(:snap_application_notification).
        and_return(fake_mailer)

      ClientEmailApplicationJob.new.perform(export: export)

      expect(ApplicationMailer).to have_received(:snap_application_notification).
        with(recipient_email: "nowhere@example.horse", application_pdf: tempfile)

      expect(fake_mailer).to have_received(:deliver)
    end
  end
end
