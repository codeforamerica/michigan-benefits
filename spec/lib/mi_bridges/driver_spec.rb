require "rails_helper"

RSpec.describe MiBridges::Driver do
  describe "#run" do
    context "first drive attempt" do
      it "creates a new drive attempt" do
        snap_application = create(:snap_application)
        factory_double = double(run: true)
        allow(MiBridges::Driver::Services::DriverApplicationFactory).
          to receive(:new).
          with(snap_application: snap_application).
          and_return(factory_double)
        driver = MiBridges::Driver.new(snap_application: snap_application)
        allow(driver).to receive(:sign_up_for_account).and_return(true)
        allow(driver).to receive(:complete_application).and_return(true)
        allow(driver).to receive(:teardown).and_return(true)

        driver.run

        expect(factory_double).to have_received(:run)
      end
    end

    context "not first drive attempt" do
      it "does not create a new drive attempt" do
        snap_application = create(:snap_application)
        create(:driver_application, snap_application: snap_application)
        factory_double = double(run: true)
        allow(MiBridges::Driver::Services::DriverApplicationFactory).
          to receive(:new).
          with(snap_application: snap_application).
          and_return(factory_double)
        driver = MiBridges::Driver.new(snap_application: snap_application)
        allow(driver).to receive(:sign_up_for_account).and_return(true)
        allow(driver).to receive(:complete_application).and_return(true)
        allow(driver).to receive(:teardown).and_return(true)

        driver.run

        expect(factory_double).not_to have_received(:run)
      end
    end

    it "runs through the create account flow" do
      snap_application = create(:snap_application)
      create(:driver_application, snap_application: snap_application)
      driver = MiBridges::Driver.new(snap_application: snap_application)
      allow(driver).to receive(:complete_application).and_return(true)
      allow(driver).to receive(:teardown).and_return(true)
      allow(driver).to receive(:run_flow).with(MiBridges::Driver::SIGN_UP_FLOW)

      driver.run

      expect(driver).to have_received(:run_flow).
        with(MiBridges::Driver::SIGN_UP_FLOW)
    end

    it "finds pages based on the title" do
      snap_application = create(:snap_application)
      create(:driver_application, snap_application: snap_application)
      driver = MiBridges::Driver.new(snap_application: snap_application)
      allow(driver).to receive(:setup).and_return(true)
      allow(driver).to receive(:sign_up_for_account).and_return(true)
      allow(driver).to receive(:teardown).and_return(true)
      logger_double = double
      allow(driver).to receive(:logger).and_return(logger_double)
      title = MiBridges::Driver::ImportantInformationPage.title
      allow(driver).to receive(:page_title).and_return(title)
      allow(driver).to receive(:run_flow).
        with([MiBridges::Driver::ImportantInformationPage])

      driver.run

      expect(driver).to have_received(:run_flow).
        with([MiBridges::Driver::ImportantInformationPage])
    end
  end
end
