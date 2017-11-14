require "rails_helper"
require_relative "../support/pdf_helper"

RSpec.describe Dhs1426Pdf do
  include PdfHelper

  describe "#completed_file" do
    it "writes application data to file" do
      member = create(
        :member,
        first_name: "Christa",
        last_name: "Tester",
      )
      medicaid_application = create(
        :medicaid_application,
        members: [member],
        stable_housing: true,
        phone_number: "0123456789",
      )
      expected_client_data = {
        primary_member_full_name: member.display_name,
      }

      expected_medicaid_data = {
        signature: medicaid_application.signature,
        mailing_address_street_address:
        medicaid_application.mailing_address.street_address,
        mailing_address_city: medicaid_application.mailing_address.city,
        mailing_address_county: medicaid_application.mailing_address.county,
        mailing_address_state: medicaid_application.mailing_address.state,
        mailing_address_zip: medicaid_application.mailing_address.zip,
        residential_address_street_address:
        medicaid_application.residential_address.street_address,
        residential_address_city: medicaid_application.residential_address.city,
        residential_address_county:
          medicaid_application.residential_address.county,
        residential_address_state:
          medicaid_application.residential_address.state,
        residential_address_zip: medicaid_application.mailing_address.zip,
        email: medicaid_application.email,
      }

      expected_phone_data = {
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
      }

      file = Dhs1426Pdf.new(
        medicaid_application: medicaid_application,
      ).completed_file

      result = filled_in_values(file: file.path)
      expected_client_data.each do |field, expected_data|
        expect(result[field.to_s].to_s).to eq expected_data.to_s
      end

      expected_medicaid_data.each do |field, expected_data|
        expect(result[field.to_s].to_s).to eq expected_data.to_s
      end

      expected_phone_data.each do |field, expected_data|
        expect(result[field.to_s].to_s).to eq expected_data.to_s
      end
    end

    it "returns the tempfile" do
      medicaid_application = create(:medicaid_application, :with_member)

      file = Dhs1426Pdf.new(
        medicaid_application: medicaid_application,
      ).completed_file

      expect(file).to be_a_kind_of(Tempfile)
    end
  end
end
