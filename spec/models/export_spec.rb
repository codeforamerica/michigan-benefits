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
      export.execute { |_snap_application, logger| logger.info("success!!!") }

      expect(export.status).to eq :succeeded
      expect(export.metadata).to include "success!!!"
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

    it "doesn't run when another export for the given destination is in " \
      "process or has succeeded" do
      previous = create(:export, destination: :email)
      export = build(:export, destination: :email,
                              snap_application: previous.snap_application)
      export.execute { "It's unnecessary!" }

      expect(export.status).to eq :unnecessary
    end

    it "does run if another export for the given destination is in process " \
      "or succeeded when forced" do

      previous = create(:export, destination: :email)
      export = build(:export, destination: :email, force: true,
                              snap_application: previous.snap_application)

      export.execute { "It's working!" }

      expect(export.status).to eq :succeeded
    end

    it "stores all the log entries in the metadata" do
      export = build(:export)
      export.execute do |_snap_application, logger|
        logger.debug("A debug line")
        logger.info("An info line")
        logger.warn("A warning line")
        logger.error("An error line")
      end

      expect(export.metadata).to include "A debug line"
      expect(export.metadata).to include "An info line"
      expect(export.metadata).to include "A warning line"
      expect(export.metadata).to include "An error line"
    end
  end
end
