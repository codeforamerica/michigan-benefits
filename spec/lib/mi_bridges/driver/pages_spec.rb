require "rails_helper"

RSpec.describe "Driver pages" do
  MiBridges::Driver::APPLY_FLOW.each do |page|
    it "has a title class method" do
      expect(page.title).to be
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
      limit = MiBridges::Driver::BasePage::INSTANTIATION_LIMIT + 1

      expect do
        limit.times { MiBridges::Driver::BasePage.new(snap_application) }
      end.to raise_error(
        MiBridges::Errors::TooManyAttempts,
        "MiBridges::Driver::BasePage",
      )
    end

    it "passes the name of the child class name to the error" do
      snap_application = double
      limit = MiBridges::Driver::BasePage::INSTANTIATION_LIMIT + 1

      module MiBridges
        class Driver
          class InstanceCheckPage < BasePage; end
        end
      end

      expect do
        limit.times do
          MiBridges::Driver::InstanceCheckPage.new(snap_application)
        end
      end.to raise_error(
        MiBridges::Errors::TooManyAttempts,
        "MiBridges::Driver::InstanceCheckPage",
      )
    end

    it "ignores the limit on pages that are instantiated many times" do
      snap_application = double
      limit = MiBridges::Driver::BasePage::INSTANTIATION_LIMIT + 1

      module MiBridges
        class Driver
          class SkipInstanceCheckPage < BasePage
            def skip_infinite_loop_check; end
          end
        end
      end

      expect do
        limit.times do
          MiBridges::Driver::SkipInstanceCheckPage.new(snap_application)
        end
      end.not_to raise_error
    end
  end
end
