require "rails_helper"

RSpec.describe FaxApplicationJob do
  describe "#perform" do
    it "creates a PDF with the snap application data" do
      snap_application = create(:snap_application, :with_member)
      tempfile = Tempfile.new("send_application_job_spec")
      pdf_double = double(completed_file: tempfile)
      allow(Dhs1171Pdf).to receive(:new).
        with(snap_application: snap_application).
        and_return(pdf_double)

      FaxApplicationJob.new.perform(snap_application_id: snap_application.id)

      expect(pdf_double).to have_received(:completed_file)
      expect(Dhs1171Pdf).to have_received(:new).
        with(snap_application: snap_application)

      tempfile.close
      tempfile.unlink
    end

    it "sends a fax" do
      snap_application = create(:snap_application, :with_member)
      tempfile = Tempfile.new("send_application_job_spec")
      file_path = tempfile.path
      pdf_double = double(completed_file: tempfile)
      allow(Dhs1171Pdf).to receive(:new).
        with(snap_application: snap_application).
        and_return(pdf_double)

      job = FaxApplicationJob.new
      allow(job).to receive(:fax_number).and_return("+15550001111")
      allow(job).to receive(:fax_recipient_name).and_return("John Doe")

      allow(Fax).to receive(:send_fax).
        with(number: "+15550001111", file: file_path, recipient: "John Doe")

      job.perform(snap_application_id: snap_application.id)

      expect(Fax).to have_received(:send_fax).
        with(number: "+15550001111", file: file_path, recipient: "John Doe")
    end

    it "doesnt send a fax if application has already been sent" do
      snap_application = create(:snap_application, :with_member)
      tempfile = Tempfile.new("send_application_job_spec")
      file_path = tempfile.path
      pdf_double = double(completed_file: tempfile)
      allow(Dhs1171Pdf).to receive(:new).
        with(snap_application: snap_application).
        and_return(pdf_double)

      job = FaxApplicationJob.new
      allow(job).to receive(:fax_number).and_return("+15550001111")
      allow(job).to receive(:fax_recipient_name).and_return("John Doe")

      allow(Fax).to receive(:send_fax).
        with(number: "+15550001111", file: file_path, recipient: "John Doe")

      snap_application.update(faxed_at: Time.zone.now)
      job.perform(snap_application_id: snap_application.id)

      expect(Fax).not_to have_received(:send_fax).
        with(number: "+15550001111", file: file_path, recipient: "John Doe")
    end
  end
end
