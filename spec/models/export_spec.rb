require "rails_helper"

RSpec.describe Export do
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

    it "doesn't care if destination is a symbol" do
      export = build(:export, destination: :email)
      expect(export).to be_valid
    end
  end
end
