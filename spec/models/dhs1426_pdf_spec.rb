require "rails_helper"
require_relative "../support/pdf_helper"

RSpec.describe Dhs1426Pdf do
  include PdfHelper

  describe "#completed_file" do
    it "writes application data to file" do
      primary_member = build(
        :member,
        first_name: "Christa",
        last_name: "Tester",
        birthday: Date.new(2017, 10, 18),
        sex: "female",
        married: true,
        caretaker_or_parent: true,
        in_college: true,
        ssn: "111223333",
        new_mom: true,
        requesting_health_insurance: true,
        citizen: true,
        employed: true,
        self_employed: true,
        employed_employer_names: ["AA Accounting", "BB Burgers"],
        employed_pay_quantities: ["11", "222"],
        employed_payment_frequency: ["Hourly", "Weekly"],
        other_income: true,
        other_income_types: [
          "alimony",
          "other",
          "pension",
          "retirement",
          "social_security",
          "unemployment",
        ],
        unemployment_income: 400,
        pay_child_support_alimony_arrears: true,
        child_support_alimony_arrears_expenses: 100,
        pay_student_loan_interest: true,
        student_loan_interest_expenses: 70,
        insured: true,
        insurance_type: "Medicare",
        tax_relationship: "Joint",
      )

      secondary_member = build(
        :member,
        first_name: "Roger",
        last_name: "Rabbit",
        birthday: Date.new(1980, 1, 20),
        sex: "male",
        spouse: primary_member,
        married: false,
        caretaker_or_parent: false,
        in_college: false,
        ssn: "444444444",
        new_mom: false,
        requesting_health_insurance: false,
        citizen: false,
        employed: false,
        self_employed: false,
        employed_employer_names: [],
        employed_pay_quantities: [],
        employed_payment_frequency: [],
        other_income: false,
        other_income_types: [],
        insured: true,
        insurance_type: "Employer or individual plan",
        tax_relationship: "Joint",
      )

      mailing_address = build(
        :mailing_address,
        street_address: "123 Main St.",
        street_address_2: "Apt B",
        city: "Pioneertown",
        county: "Candyland",
        state: "CA",
        zip: "19191",
      )

      residential_address = build(
        :residential_address,
        street_address: "321 Yellow Brick St.",
        street_address_2: "Apt C",
        city: "Bedrock",
        county: "Yolo",
        state: "AZ",
        zip: "88888",
      )

      medicaid_application = create(
        :medicaid_application,
        members: [primary_member, secondary_member],
        stable_housing: true,
        phone_number: "0123456789",
        flint_water_crisis: true,
        need_medical_expense_help_3_months: true,
        anyone_insured: true,
        signature: "Christa blah blah",
        signed_at: Date.new(2007, 12, 25),
        addresses: [mailing_address, residential_address],
        email: "annie@thedog.com",
        filing_federal_taxes_next_year: true,
      )

      expected_client_data = {
        primary_member_full_name: "Christa Tester",
        primary_member_birthday: "10/18/2017",
        primary_member_sex_female: "Yes",
        primary_member_married_yes: "Yes",
        primary_member_caretaker_yes: "Yes",
        primary_member_in_college_yes: "Yes",
        primary_member_under_21_yes: "Yes",
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
        primary_member_requesting_health_insurance_yes: "Yes",
        primary_member_citizen_yes: "Yes",
        primary_member_tax_relationship_joint_yes: "Yes",
        primary_member_joint_filing_member_name: "Roger Rabbit",
        second_member_birthday: "01/20/1980",
        second_member_sex_male: "Yes",
        second_member_married_no: "Yes",
        second_member_spouse_name: "Christa Tester",
        second_member_caretaker_no: "Yes",
        second_member_in_college_no: "Yes",
        second_member_under_21_no: "Yes",
        second_member_ssn_0: "4",
        second_member_ssn_1: "4",
        second_member_ssn_2: "4",
        second_member_ssn_3: "4",
        second_member_ssn_4: "4",
        second_member_ssn_5: "4",
        second_member_ssn_6: "4",
        second_member_ssn_7: "4",
        second_member_ssn_8: "4",
        second_member_new_mom_no: "Yes",
        second_member_requesting_health_insurance_no: "Yes",
        second_member_citizen_no: "Yes",
      }

      expected_medicaid_data = {
        signature: "Christa blah blah",
        signature_date: "12/25/2007",
        mailing_address_street_address:
          "123 Main St.",
        mailing_address_street_address_2: "Apt B",
        mailing_address_city: "Pioneertown",
        mailing_address_county: "Candyland",
        mailing_address_state: "CA",
        mailing_address_zip: "19191",
        residential_address_street_address: "321 Yellow Brick St.",
        residential_address_street_address_2: "Apt C",
        residential_address_city: "Bedrock",
        residential_address_county: "Yolo",
        residential_address_state: "AZ",
        residential_address_zip: "88888",
        email: "annie@thedog.com",
        flint_water_yes: "Yes",
        need_medical_expense_help_3_months_yes: "Yes",
        anyone_insured_yes: "Yes",
        insured_medicare_yes: "Yes",
        insured_medicare_member_names: "Christa",
        insured_employer_yes: "Yes",
        insured_employer_member_names: "Roger",
        help_paying_medicare_premiums_yes: "Yes",
        filing_federal_taxes_next_year_yes: "Yes",
        any_member_tax_relationship_dependent_no: "Yes",
        dependent_member_names: "",
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

      expected_primary_member_income_and_expenses = {
        primary_member_employed: "Yes",
        primary_member_self_employed: "Yes",
        primary_member_first_employed_employer_name: "AA Accounting",
        primary_member_first_employed_pay_interval_hourly: "Yes",
        primary_member_first_employed_pay_quantity: "11",
        primary_member_second_employed_employer_name: "BB Burgers",
        primary_member_second_employed_pay_interval_weekly: "Yes",
        primary_member_second_employed_pay_quantity: "222",
        primary_member_additional_income_unemployment: "Yes",
        primary_member_additional_income_pension: "Yes",
        primary_member_additional_income_social_security: "Yes",
        primary_member_additional_income_retirement: "Yes",
        primary_member_additional_income_alimony: "Yes",
        primary_member_additional_income_other: "Yes",
        primary_member_additional_income_unemployment_amount: "400",
        primary_member_additional_income_unemployment_interval: "Monthly",
        primary_member_deduction_alimony_yes: "Yes",
        primary_member_deduction_student_loan_yes: "Yes",
        primary_member_deduction_child_support_alimony_arrears_amount: "100",
        primary_member_deduction_child_support_alimony_arrears_interval:
          "Monthly",
        primary_member_deduction_student_loan_interest_amount: "70",
        primary_member_deduction_student_loan_interest_interval: "Monthly",
        primary_member_claimed_as_dependent_no: "Yes",
      }

      expected_second_member_income_and_expenses = {
        second_member_not_employed: "Yes",
        second_member_additional_income_none: "Yes",
      }

      file = Dhs1426Pdf.new(
        medicaid_application: medicaid_application,
      ).completed_file

      result = filled_in_values(file: file.path)

      [
        expected_client_data,
        expected_medicaid_data,
        expected_phone_data,
        expected_primary_member_income_and_expenses,
        expected_second_member_income_and_expenses,
      ].each do |expected_data_hash|
        expected_data_hash.each do |field, expected_data|
          failure_msg = "Expected '#{expected_data}' for #{field}, " +
            "but got '#{result[field.to_s]}'"
          expect(result[field.to_s].to_s).to eq(expected_data.to_s), failure_msg
        end
      end
    end

    it "returns the tempfile" do
      medicaid_application = create(:medicaid_application, :with_member)

      file = Dhs1426Pdf.new(
        medicaid_application: medicaid_application,
      ).completed_file

      expect(file).to be_a_kind_of(Tempfile)
    end

    it "does not fail for empty medicaid applications" do
      medicaid_application = create(:medicaid_application, :with_member)

      Dhs1426Pdf.new(
        medicaid_application: medicaid_application,
      ).completed_file
    end

    it "appends pages if there are more than 2 household members" do
      members = build_list(:member, 4)
      medicaid_application = create(:medicaid_application, members: members)
      original_length = PDF::Reader.new(Dhs1426Pdf::SOURCE_PDF).page_count

      file = Dhs1426Pdf.new(medicaid_application: medicaid_application).
        completed_file
      new_pdf = PDF::Reader.new(file.path)
      pages_per_member = 2
      cover_sheet_pages = 1

      expect(new_pdf.page_count).to eq(
        original_length +
        cover_sheet_pages +
        (2 * pages_per_member),
      )
    end

    it "prepends the additional member page fields with numbers" do
      members = [
        build(:member, first_name: "Primera"),
        build(:member, first_name: "Segunda"),
        build(:member, first_name: "Tercera"),
        build(:member, first_name: "Cuarta"),
      ]
      medicaid_application = create(:medicaid_application, members: members)
      file = Dhs1426Pdf.new(medicaid_application: medicaid_application).
        completed_file
      result = filled_in_values(file: file.path)
      expect(result["primary_member_full_name"]).to include("Primera")
      expect(result["second_member_full_name"]).to include("Segunda")
      expect(result["1.second_member_full_name"]).to include("Tercera")
      expect(result["2.second_member_full_name"]).to include("Cuarta")
    end

    it "appends pages if there are verification documents" do
      paperwork_path = "http://example.com"
      verification_document = double
      allow(verification_document).to receive(:file).and_return(
        File.open("spec/fixtures/test_pdf.pdf"),
      )
      medicaid_application =
        create(:medicaid_application, :with_member, paperwork: [paperwork_path])
      allow(VerificationDocument).to receive(:new).with(
        url: paperwork_path,
        benefit_application: medicaid_application,
      ).and_return(verification_document)
      original_length = PDF::Reader.new(Dhs1426Pdf::SOURCE_PDF).page_count

      file = Dhs1426Pdf.
        new(medicaid_application: medicaid_application).
        completed_file
      new_pdf = PDF::Reader.new(file.path)

      expect(new_pdf.page_count).to eq(original_length + 2)
    end
  end
end
