require "rails_helper"

RSpec.describe Integrated::ClientEmailApplicationJob do
  describe "#perform" do
    it "sends an email" do
      tempfile = double("tempfile")
      integrated_application = instance_double(CommonApplication,
        id: 1,
        email: "me@email.com",
        pdf: tempfile)
      export = double("export")

      allow(export).to receive(:execute).and_yield(
        integrated_application, double("logger").as_null_object
      )

      fake_message = double("message", deliver: nil)
      expect(ApplicationMailer).to receive(:client_integrated_application_notification).
        with(recipient_email: "me@email.com",
             application_pdf: tempfile) { fake_message }

      expect(fake_message).to receive(:deliver)

      Integrated::ClientEmailApplicationJob.new.perform(export: export)
    end
  end
end
