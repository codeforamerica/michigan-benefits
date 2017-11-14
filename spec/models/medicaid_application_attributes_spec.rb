require "rails_helper"

RSpec.describe MedicaidApplicationAttributes do
  describe "#to_h" do
    it "returns a hash of attributes" do
      mailing_address = build(:mailing_address)
      residential_address = build(
        :residential_address,
        street_address: "456 I Live Here Ave",
        city: "Other",
        zip: "54321",
      )
      medicaid_application = create(
        :medicaid_application,
        signature: "Jane Hancock",
        addresses: [residential_address, mailing_address],
        stable_housing: true,
        phone_number: "0123456789",
        email: "person@example.com",

      )

      data = MedicaidApplicationAttributes.new(
        medicaid_application: medicaid_application,
      ).to_h

      expect(data).to eq(
        signature: "Jane Hancock",
        mailing_address_city: "Flint",
        mailing_address_county: "Genesee",
        mailing_address_state: "MI",
        mailing_address_street_address: "123 Main St.",
        mailing_address_zip: "12345",
        residential_address_city: "Other",
        residential_address_county: "Genesee",
        residential_address_state: "MI",
        residential_address_street_address: "456 I Live Here Ave",
        residential_address_zip: "54321",
        phone_number_0: "0",
        phone_number_1: "1",
        phone_number_2: "2",
        phone_number_3: "3",
        phone_number_4: "4",
        phone_number_5: "5",
        phone_number_6: "6",
        phone_number_7: "7",
        phone_number_8: "8",
        phone_number_9: "9",
        preferred_language: nil,
        email: "person@example.com",
        receive_info_by_email: "Yes",
        not_receive_info_by_email: nil,
      )
    end

    context "unstable housing" do
      it "returns residential address as Homeless" do
        medicaid_application = create(
          :medicaid_application,
          stable_housing: false,
        )

        data = MedicaidApplicationAttributes.new(
          medicaid_application: medicaid_application,
        ).to_h

        expect(data).to include(
          residential_address_street_address: "Homeless",
        )
      end
    end
  end
end
