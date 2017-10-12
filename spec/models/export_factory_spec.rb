require "rails_helper"

RSpec.describe ExportFactory do
  describe "#enqueue" do
    it "sends fax" do
      allow(FaxApplicationJob).to receive(:perform_later)
      enqueuer = ExportFactory.new
      export = build(:export, destination: :fax)
      enqueuer.enqueue(export)
      expect(FaxApplicationJob).to have_received(:perform_later).
        with(export: export)
    end

    it "sends email to client" do
      allow(ClientEmailApplicationJob).to receive(:perform_later)
      enqueuer = ExportFactory.new
      export = build(:export, destination: :client_email)
      enqueuer.enqueue(export)
      expect(ClientEmailApplicationJob).to have_received(:perform_later).
        with(export: export)
    end

    it "exports to MI Bridges" do
      allow(SubmitApplicationViaMiBridgesJob).to receive(:perform_later)
      enqueuer = ExportFactory.new
      export = build(:export, destination: :mi_bridges)
      enqueuer.enqueue(export)
      expect(SubmitApplicationViaMiBridgesJob).to have_received(:perform_later).
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
      allow(FaxApplicationJob).to receive(:perform_later)
      allow(ClientEmailApplicationJob).to receive(:perform_later)
      allow(SubmitApplicationViaMiBridgesJob).to receive(:perform_later)
      enqueuer = ExportFactory.new

      export = build(:export, destination: nil)

      expect do
        enqueuer.enqueue(export)
      end.to raise_error(ActiveRecord::RecordInvalid)

      expect(export).not_to be_persisted
      expect(FaxApplicationJob).not_to have_received(:perform_later)
      expect(ClientEmailApplicationJob).not_to have_received(:perform_later)
      expect(SubmitApplicationViaMiBridgesJob).
        not_to have_received(:perform_later)
    end
  end
end
