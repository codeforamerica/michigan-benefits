require "rails_helper"

RSpec.describe FaxApplicationJob do
  describe "#perform" do
    it "sends a fax when the application hasn't been faxed already" do
      snap_application = create(:snap_application, :with_member)

      job = FaxApplicationJob.new

      allow(Fax).to receive(:send_fax)
      recipient = FaxRecipient.new(residential_address:
                                   snap_application.residential_address)

      job.perform(snap_application_id: snap_application.id)

      snap_application.reload

      expect(snap_application).to be_faxed

      expect(Fax).to have_received(:send_fax).
        with(hash_including(number: recipient.number,
                            recipient: recipient.name))
    end

    it "doesnt send a fax if application has already been sent" do
      snap_application = create(:snap_application, :with_member)
      job = FaxApplicationJob.new

      allow(Fax).to receive(:send_fax)

      snap_application.update(faxed_at: Time.zone.now)

      job.perform(snap_application_id: snap_application.id)

      expect(Fax).not_to have_received(:send_fax)
    end
  end
end
