require "rails_helper"

RSpec.describe "Driver pages" do
  MiBridges::Driver::APPLY_FLOW.each do |page|
    it "has a TITLE constant" do
      expect(page::TITLE).to be
    end

    describe "methods" do
      it "setup, fill_in_required_fields, continue are defined" do
        snap_application = double
        page = page.new(snap_application)

        expect(page).to respond_to(:setup)
        expect(page).to respond_to(:fill_in_required_fields)
        expect(page).to respond_to(:continue)
      end
    end
  end

  context "when instantiating a page too many times" do
    it "raises an exception" do
      snap_application = double

      expect do
        6.times { MiBridges::Driver::BasePage.new(snap_application) }
      end.to raise_error(
        MiBridges::Errors::TooManyAttempts,
        "MiBridges::Driver::BasePage",
      )
    end

    it "passes the name of the child class name to the error" do
      snap_application = double

      expect do
        6.times { MiBridges::Driver::HomePage.new(snap_application) }
      end.to raise_error(
        MiBridges::Errors::TooManyAttempts,
        "MiBridges::Driver::HomePage",
      )
    end
  end
end
