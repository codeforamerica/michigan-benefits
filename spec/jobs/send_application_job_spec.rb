require "rails_helper"

RSpec.describe SendApplicationJob do
  describe "#perform" do
    it "creates a PDF with the snap application data" do
      pdf_double = double(save: true)
      allow(Dhs1171Pdf).to receive(:new).with(snap_application: snap_application, output_filename: "test_pdf.pdf").and_return(pdf_double)

      SendApplicationJob.new.perform(snap_application: snap_application)

      expect(pdf_double).to have_received(:save)
    end

    it "sends an email" do
      expect do
        SendApplicationJob.new.perform(snap_application: snap_application)
      end.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end

  def snap_application
    @_snap_application ||= FactoryGirl.create(:snap_application)
  end
end
