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
end
