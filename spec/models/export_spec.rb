require "rails_helper"

RSpec.describe Export do
  describe ".enqueue_faxes" do
    it "schedules jobs for signed, unfaxed application updated awhile ago" do
      after_threshold = (Export::DELAY_THRESHOLD + 1).minutes.ago
      before_threshold = (Export::DELAY_THRESHOLD - 1).minutes.ago
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
          with(export: signed_unfaxed_updated_awhile_ago.exports.first),
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
        with(export: export)
    end

    it "sends email" do
      export = build(:export, destination: :email)
      export.enqueue
      expect(EmailApplicationJob).to have_received(:perform_later).
        with(export: export)
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

  describe "#execute" do
    it "requires a block" do
      export = build(:export)
      expect { export.execute }.to raise_error(ArgumentError)
    end

    it "always saves it's exports!" do
      export = build(:export)
      export.execute { "I'm a noop" }
      expect(export).to be_persisted
    end

    it "frees up the snap applications PDF" do
      export = build(:export)
      export.execute { "I'm a noop" }
      expect(export.snap_application.pdf).to be_closed
    end
    it "yields the snap application to the block" do
      fake_job = double(call: "I did a thing?")
      export = build(:export)
      export.execute { |value| fake_job.call(value) }
      expect(fake_job).to have_received(:call).with(export.snap_application)
    end

    it "transitions to success and stores results if the block doesnt throw" do
      export = build(:export)
      export.execute { "success!!!" }

      expect(export.status).to eq :succeeded
      expect(export.metadata).to eq "success!!!"
    end

    it "transitions to failure and doesnt yield the block if a previous " \
      "export of its kind succeeded" do
      successful_export = create(:export, :succeeded)
      export = build(:export,
                     snap_application: successful_export.snap_application)

      fake_job = double(call: "I did a thing?")
      export.execute { fake_job.call }
      expect(export.status).to eq :failed
      expect(fake_job).not_to have_received(:call)
    end

    it "transitions to failure and stores stacktrace and re-raises if the " \
      "block throws" do
      export = build(:export)

      expect do
        export.execute { |_value| raise "We did a bad" }
      end.to raise_error StandardError

      expect(export).to be_persisted
      expect(export.status).to eq :failed
      expect(export.metadata).to include "We did a bad"
    end
  end
end
