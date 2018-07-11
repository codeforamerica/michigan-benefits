require "rails_helper"

RSpec.describe OfficeLocationForm do
  describe "validations" do
    context "when office location is provided" do
      it "is valid" do
        form = OfficeLocationForm.new(
          selected_office_location: "clio",
        )

        expect(form).to be_valid
      end
    end

    context "when no office location is provided" do
      it "is invalid" do
        form = OfficeLocationForm.new(
          selected_office_location: nil,
        )

        expect(form).to_not be_valid
      end
    end
  end
end
