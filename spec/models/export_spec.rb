require "rails_helper"

RSpec.describe Export do
  describe ".enqueue_faxes" do
    it "schedules jobs for signed, unfaxed application updated awhile ago" do
      A_WHILE_AGO = 31.minutes.ago
      RECENTLY = 25.minutes.ago
      signed_unfaxed_updated_awhile_ago = create(:snap_application,
                                                 signed_at: A_WHILE_AGO,
                                                 updated_at: A_WHILE_AGO)

      signed_unfaxed_updated_recently = create(:snap_application,
                                               signed_at: RECENTLY,
                                               updated_at: RECENTLY)

      unsigned_unfaxed_updated_awhile_ago = create(:snap_application,
                                                   signed_at: nil,
                                                   updated_at: A_WHILE_AGO)

      signed_faxed_updated_awhile_ago = create(:snap_application,
                                               :faxed_successfully,
                                               signed_at: A_WHILE_AGO,
                                               updated_at: A_WHILE_AGO)

      allow(FaxApplicationJob).to receive(:perform_later)

      Export.enqueue_faxes

      expect(signed_faxed_updated_awhile_ago.exports.length).to eql 1
      expect(unsigned_unfaxed_updated_awhile_ago.exports).to be_empty
      expect(signed_unfaxed_updated_recently.exports).to be_empty

      expected_export_group = signed_unfaxed_updated_awhile_ago.exports
      expect(expected_export_group).not_to be_empty
      expect(expected_export_group.first.status).to eq :queued

      expect(FaxApplicationJob).to have_received(:perform_later).once
      expect(FaxApplicationJob).to(
        have_received(:perform_later).
          with(export_id: signed_unfaxed_updated_awhile_ago.exports.first.id),
      )
    end
  end

  describe "#enqueue" do
    before do
      allow(FaxApplicationJob).to receive(:perform_later)
      allow(EmailApplicationJob).to receive(:perform_later)
    end

    it "sends fax" do
      export = build(:export, destination: :fax)
      export.enqueue
      expect(FaxApplicationJob).to have_received(:perform_later).
        with(export_id: export.id)
    end

    it "sends email" do
      export = build(:export, destination: :email)
      export.enqueue
      expect(EmailApplicationJob).to have_received(:perform_later).
        with(export_id: export.id)
    end

    it "transitions status" do
      export = build(:export)
      export.enqueue
      expect(export.status).to eq :queued
    end

    it "persists the export if it hasn't been persisted yet" do
      export = build(:export)
      export.enqueue
      expect(export).to be_persisted
    end

    it "doesn't care if destination is a symbol" do
      export = build(:export, destination: :email)
      expect(export).to be_valid
    end

    it "raises an exception if the export isn't valid" do
      export = build(:export, destination: nil)
      expect do
        export.enqueue
      end.to raise_error(ActiveRecord::RecordInvalid)
      expect(export).not_to be_persisted
      expect(FaxApplicationJob).not_to have_received(:perform_later)
      expect(EmailApplicationJob).not_to have_received(:perform_later)
    end
  end
end
