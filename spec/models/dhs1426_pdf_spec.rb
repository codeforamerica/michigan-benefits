require "rails_helper"
require_relative "../support/pdf_helper"

RSpec.describe Dhs1426Pdf do
  include PdfHelper

  describe "#completed_file" do
    it "writes application data to file" do
      primary_member = create(
        :member,
        first_name: "Christa",
        last_name: "Tester",
        birthday: Date.new(2017, 10, 18),
        sex: "female",
        married: true,
        caretaker_or_parent: true,
        in_college: true,
        spouse: create(:member, first_name: "Candy", last_name: "Crush"),
        ssn: "111223333",
        new_mom: true,
        requesting_health_insurance: true,
        citizen: true,
      )
      secondary_member = create(
        :member,
        first_name: "Roger",
        last_name: "Rabbit",
        birthday: Date.new(1980, 1, 20),
        sex: "male",
        married: false,
        caretaker_or_parent: false,
        in_college: false,
        new_mom: false,
        requesting_health_insurance: false,
        citizen: false,
      )
      medicaid_application = create(
        :medicaid_application,
        members: [primary_member, secondary_member],
        stable_housing: true,
        phone_number: "0123456789",
        flint_water_crisis: true,
        need_medical_expense_help_3_months: true,
      )
      expected_client_data = {
        primary_member_full_name: "Christa Tester",
        primary_member_birthday: "10/18/2017",
        primary_member_sex_male: nil,
        primary_member_sex_female: "Yes",
        primary_member_married_yes: "Yes",
        primary_member_married_no: nil,
        primary_member_spouse_name: "Candy Crush",
        primary_member_caretaker_yes: "Yes",
        primary_member_caretaker_no: nil,
        primary_member_in_college_yes: "Yes",
        primary_member_in_college_no: nil,
        primary_member_under_21_yes: "Yes",
        primary_member_under_21_no: nil,
        primary_member_ssn_0: 1,
        primary_member_ssn_1: 1,
        primary_member_ssn_2: 1,
        primary_member_ssn_3: 2,
        primary_member_ssn_4: 2,
        primary_member_ssn_5: 3,
        primary_member_ssn_6: 3,
        primary_member_ssn_7: 3,
        primary_member_ssn_8: 3,
        primary_member_new_mom_yes: "Yes",
        primary_member_new_mom_no: nil,
        primary_member_requesting_health_insurance_yes: "Yes",
        primary_member_requesting_health_insurance_no: nil,
        primary_member_citizen_yes: "Yes",
        primary_member_citizen_no: nil,
        second_member_birthday: "01/20/1980",
        second_member_sex_male: "Yes",
        second_member_sex_female: nil,
        second_member_married_yes: nil,
        second_member_married_no: "Yes",
        second_member_spouse_name: nil,
        second_member_caretaker_yes: nil,
        second_member_caretaker_no: "Yes",
        second_member_in_college_yes: nil,
        second_member_in_college_no: "Yes",
        second_member_under_21_yes: nil,
        second_member_under_21_no: "Yes",
        second_member_ssn_0: nil,
        second_member_ssn_1: nil,
        second_member_ssn_2: nil,
        second_member_ssn_3: nil,
        second_member_ssn_4: nil,
        second_member_ssn_5: nil,
        second_member_ssn_6: nil,
        second_member_ssn_7: nil,
        second_member_ssn_8: nil,
        second_member_new_mom_yes: nil,
        second_member_new_mom_no: "Yes",
        second_member_requesting_health_insurance_yes: nil,
        second_member_requesting_health_insurance_no: "Yes",
        second_member_citizen_yes: nil,
        second_member_citizen_no: "Yes",
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
        flint_water_yes: "Yes",
        flint_water_no: nil,
        need_medical_expense_help_3_months_yes: "Yes",
        need_medical_expense_help_3_months_no: nil,
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
