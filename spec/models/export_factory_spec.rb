require "rails_helper"

RSpec.describe ExportFactory do
  describe "#enqueue_faxes" do
    it "schedules jobs for signed, unfaxed application updated awhile ago" do
      after_threshold = (ExportFactory::DELAY_THRESHOLD + 1).minutes.ago
      before_threshold = (ExportFactory::DELAY_THRESHOLD - 1).minutes.ago
      signed_unfaxed_updated_awhile_ago = create(:snap_application,
                                                 signed_at: after_threshold,
                                                 updated_at: after_threshold)

      signed_unfaxed_updated_recently = create(:snap_application,
                                               signed_at: before_threshold,
                                               updated_at: before_threshold)

      unsigned_unfaxed_updated_awhile_ago = create(:snap_application,
                                                   signed_at: nil,
                                                   updated_at: after_threshold)

      signed_faxed_updated_awhile_ago = create(:snap_application, :faxed,
                                               signed_at: after_threshold,
                                               updated_at: after_threshold)

      allow(FaxApplicationJob).to receive(:perform_later)

      ExportFactory.export_unfaxed_snap_applications

      expect(signed_faxed_updated_awhile_ago.exports.length).to eql 1
      expect(unsigned_unfaxed_updated_awhile_ago.exports).to be_empty
      expect(signed_unfaxed_updated_recently.exports).to be_empty

      expected_export_group = signed_unfaxed_updated_awhile_ago.exports
      expect(expected_export_group).not_to be_empty
      expect(expected_export_group.first.status).to eq :queued

      expect(FaxApplicationJob).to have_received(:perform_later).once
      expect(FaxApplicationJob).to(
        have_received(:perform_later).
          with(export: signed_unfaxed_updated_awhile_ago.exports.first),
      )
    end
  end

  describe "#enqueue" do
    before do
      allow(FaxApplicationJob).to receive(:perform_later)
      allow(ClientEmailApplicationJob).to receive(:perform_later)
    end

    it "sends fax" do
      enqueuer = ExportFactory.new
      export = build(:export, destination: :fax)
      enqueuer.enqueue(export)
      expect(FaxApplicationJob).to have_received(:perform_later).
        with(export: export)
    end

    it "sends email to client" do
      enqueuer = ExportFactory.new
      export = build(:export, destination: :client_email)
      enqueuer.enqueue(export)
      expect(ClientEmailApplicationJob).to have_received(:perform_later).
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
      enqueuer = ExportFactory.new
      export = build(:export, destination: nil)
      expect do
        enqueuer.enqueue(export)
      end.to raise_error(ActiveRecord::RecordInvalid)
      expect(export).not_to be_persisted
      expect(FaxApplicationJob).not_to have_received(:perform_later)
      expect(ClientEmailApplicationJob).not_to have_received(:perform_later)
    end
  end
end
