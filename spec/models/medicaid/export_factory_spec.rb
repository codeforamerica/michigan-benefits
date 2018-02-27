require "rails_helper"

RSpec.describe Medicaid::ExportFactory do
  describe "#enqueue" do
    it "sends email to office" do
      allow(Medicaid::OfficeEmailApplicationJob).to receive(:perform_later)
      enqueuer = Medicaid::ExportFactory.new
      export = build(:export, :medicaid_application, destination: :office_email)

      enqueuer.enqueue(export)

      expect(Medicaid::OfficeEmailApplicationJob).
        to have_received(:perform_later).
        with(export: export)
    end

    it "transitions status" do
      enqueuer = Medicaid::ExportFactory.new
      export = build(:export, :medicaid_application, destination: :office_email)
      enqueuer.enqueue(export)
      expect(export.status).to eq :queued
    end

    it "persists the export if it hasn't been persisted yet" do
      enqueuer = Medicaid::ExportFactory.new
      export = build(:export, :medicaid_application, destination: :office_email)
      enqueuer.enqueue(export)
      expect(export).to be_persisted
    end
  end
end
