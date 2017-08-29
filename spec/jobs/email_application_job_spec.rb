require "rails_helper"

RSpec.describe EmailApplicationJob do
  describe "#perform" do
    it "creates a PDF with the snap application data" do
      snap_application = create(:snap_application, :with_member)
      tempfile = Tempfile.new("send_application_job_spec")
      pdf_double = double(completed_file: tempfile)
      allow(Dhs1171Pdf).to receive(:new).
        with(snap_application: snap_application).
        and_return(pdf_double)

      EmailApplicationJob.new.perform(snap_application: snap_application)

      expect(pdf_double).to have_received(:completed_file)
      expect(Dhs1171Pdf).to have_received(:new).
        with(snap_application: snap_application)

      tempfile.close
      tempfile.unlink
    end

    it "sends an email" do
      snap_application = create(:snap_application, :with_member)

      expect do
        EmailApplicationJob.new.perform(snap_application: snap_application)
      end.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end
