require "rails_helper"

RSpec.describe SendApplicationJob do
  describe "#perform" do
    it "creates a PDF with the snap application data" do
      snap_application = create(:snap_application, :with_member)
      tempfile = Tempfile.new("send_application_job_spec")
      pdf_double = double(completed_file: tempfile)
      allow(Dhs1171Pdf).to receive(:new).
        with(snap_application: snap_application).
        and_return(pdf_double)

      SendApplicationJob.new.perform(snap_application: snap_application)

      expect(pdf_double).to have_received(:completed_file)
      expect(Dhs1171Pdf).to have_received(:new).
        with(snap_application: snap_application)

      tempfile.close
      tempfile.unlink
    end

    it "sends an email" do
      snap_application = create(:snap_application, :with_member)

      expect do
        SendApplicationJob.new.perform(snap_application: snap_application)
      end.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    context "when a fax phone number is set" do
      it "sends a fax" do
        snap_application = create(:snap_application, :with_member)
        tempfile = Tempfile.new("send_application_job_spec")
        file_path = tempfile.path
        pdf_double = double(completed_file: tempfile)
        allow(Dhs1171Pdf).to receive(:new).
          with(snap_application: snap_application).
          and_return(pdf_double)

        job = SendApplicationJob.new
        allow(job).to receive(:fax_number).and_return("+15550001111")
        allow(job).to receive(:fax_recipient_name).and_return("John Doe")

        allow(Fax).to receive(:send_fax).
          with(number: "+15550001111", file: file_path, recipient: "John Doe")

        job.perform(snap_application: snap_application)

        expect(Fax).to have_received(:send_fax).
          with(number: "+15550001111", file: file_path, recipient: "John Doe")
      end
    end

    context "when no fax number is set" do
      it "does not send a fax" do
        snap_application = create(:snap_application, :with_member)
        tempfile = Tempfile.new("send_application_job_spec")
        pdf_double = double(completed_file: tempfile)
        allow(Dhs1171Pdf).to receive(:new).
          with(snap_application: snap_application).
          and_return(pdf_double)
        allow(Fax).to receive(:send_fax)

        SendApplicationJob.new.perform(snap_application: snap_application)

        expect(Fax).not_to have_received(:send_fax)
      end
    end
  end
end
