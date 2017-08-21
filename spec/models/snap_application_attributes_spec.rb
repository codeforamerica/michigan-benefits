require "rails_helper"

RSpec.describe SnapApplicationAttributes do
  describe "#to_h" do
    it "returns a hash of attributes" do
      mailing_address = create(:mailing_address)
      residential_address = create(:address)
      snap_application = create(
        :snap_application,
        :with_member,
        addresses: [mailing_address, residential_address],
      )

      data =
        SnapApplicationAttributes.new(snap_application: snap_application).to_h

      expect(data).to eq(
        applying_for_food_assistance: "Yes",
        birth_day: "18",
        birth_month: "08",
        birth_year: "1990",
        email: "test@example.com",
        mailing_address_city: "Flint",
        mailing_address_county: "Genesee",
        mailing_address_state: "MI",
        mailing_address_street_address: "123 Main St.",
        mailing_address_zip: "12345",
        members_buy_food_with_no: "Yes",
        members_buy_food_with_yes: nil,
        members_not_buy_food_with: "",
        phone_number: nil,
        residential_address_city: nil,
        residential_address_county: nil,
        residential_address_state: nil,
        residential_address_street_address: nil,
        residential_address_zip: "12345",
        signature: "Mr. RJD2",
        signature_date: snap_application.signed_at.to_s,
      )
    end
  end
end
