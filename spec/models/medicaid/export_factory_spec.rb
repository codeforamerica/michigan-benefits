require "rails_helper"

RSpec.describe Medicaid::ExportFactory do
  describe "#enqueue" do
    it "sends email to office" do
      allow(Medicaid::OfficeEmailApplicationJob).to receive(:perform_later)
      enqueuer = Medicaid::ExportFactory.new
      export = build(:export, destination: :office_email)

      enqueuer.enqueue(export)

      expect(Medicaid::OfficeEmailApplicationJob).
        to have_received(:perform_later).
        with(export: export)
    end

    it "transitions status" do
      enqueuer = ExportFactory.new
      export = build(:export)
      enqueuer.enqueue(export)
      expect(export.status).to eq :queued
    end

    it "persists the export if it hasn't been persisted yet" do
      enqueuer = ExportFactory.new
      export = build(:export)
      enqueuer.enqueue(export)
      expect(export).to be_persisted
    end

    it "raises an exception if the export isn't valid" do
      allow(ClientEmailApplicationJob).to receive(:perform_later)
      allow(SubmitApplicationViaMiBridgesJob).to receive(:perform_later)
      enqueuer = ExportFactory.new

      export = build(:export, destination: nil)

      expect do
        enqueuer.enqueue(export)
      end.to raise_error(ActiveRecord::RecordInvalid)

      expect(export).not_to be_persisted
      expect(ClientEmailApplicationJob).not_to have_received(:perform_later)
      expect(SubmitApplicationViaMiBridgesJob).
        not_to have_received(:perform_later)
    end
  end
end
