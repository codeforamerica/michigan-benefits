require "rails_helper"

RSpec.describe ClientEmailApplicationJob do
  describe "#perform" do
    it "creates a PDF with the snap application data" do
      snap_application = create(:snap_application, :with_member)
      export = Export.create(
        benefit_application: snap_application,
        destination: :fax,
      )

      fake_mailer = double(deliver: nil)
      allow(ApplicationMailer).to receive(:snap_application_notification).
        and_return(fake_mailer)

      ClientEmailApplicationJob.new.perform(export: export)

      expect(ApplicationMailer).to(
        have_received(:snap_application_notification).
          with(hash_including(recipient_email: snap_application.email)),
      )

      expect(fake_mailer).to have_received(:deliver)
    end
  end
end
