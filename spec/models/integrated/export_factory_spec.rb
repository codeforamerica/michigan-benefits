require "rails_helper"

RSpec.describe Integrated::ExportFactory do
  describe "#enqueue" do
    it "sends email to office" do
      allow(Integrated::OfficeEmailApplicationJob).to receive(:perform_later)
      enqueuer = Integrated::ExportFactory.new
      export = build(:export, :common_application, destination: :office_email)

      enqueuer.enqueue(export)

      expect(Integrated::OfficeEmailApplicationJob).
        to have_received(:perform_later).
        with(export: export)
    end

    it "transitions status" do
      enqueuer = Integrated::ExportFactory.new
      export = build(:export, :common_application, destination: :office_email)
      enqueuer.enqueue(export)
      expect(export.status).to eq :queued
    end

    it "persists the export if it hasn't been persisted yet" do
      enqueuer = Integrated::ExportFactory.new
      export = build(:export, :common_application, destination: :office_email)
      enqueuer.enqueue(export)
      expect(export).to be_persisted
    end

    it "raises an exception if export destination isn't supported" do
      enqueuer = Integrated::ExportFactory.new
      export = build(:export, :common_application, destination: :mi_bridges)

      expect do
        enqueuer.enqueue(export)
      end.to raise_error(Integrated::ExportFactory::UnknownExportTypeError)
    end
  end
end
