require "rails_helper"

RSpec.describe AssistanceApplicationForm do
  describe "pdf component" do
    let(:subject) do
      AssistanceApplicationForm.new(double("fake application"))
    end

    it_should_behave_like "pdf component"
  end

  describe "#fill?" do
    it "responds to fill? and returns true" do
      form = AssistanceApplicationForm.new(double("fake application"))
      expect(form.fill?).to be_truthy
    end
  end

  describe "#attributes" do
    context "an application with one member" do
      let(:primary_member) do
        build(:household_member,
          first_name: "Octopus",
          last_name: "Cuttlefish",
          relationship: "primary",
          birthday: DateTime.new(1991, 10, 18),
          sex: "male",
          ssn: "123456789",
          requesting_food: "yes",
          requesting_healthcare: "yes",
          married: "yes",
          student: "yes",
          disabled: "yes",
          citizen: "yes",
          veteran: "yes",
          pregnant: "no",
          pregnancy_expenses: "yes",
          employments: [build(:employment)],
          self_employed: "yes",
          incomes: [build(:income, income_type: "unemployment")])
      end

      let(:common_application) do
        create(:common_application,
           members: [primary_member],
           expenses: [
             build(:expense, expense_type: "health_insurance"),
             build(:expense, expense_type: "childcare"),
             build(:expense, expense_type: "child_support"),
             build(:expense, expense_type: "student_loan_interest"),
           ],
           residential_address: build(:residential_address,
                                      address_type: "residential",
                                      street_address: "123 Main St",
                                      street_address_2: "Apt B",
                                      city: "Flint",
                                      county: "Genesee",
                                      state: "MI",
                                      zip: "48480"),
           mailing_address: build(:mailing_address,
                                  address_type: "mailing",
                                  street_address: "456 Mailing Ave",
                                  street_address_2: "Suite 500",
                                  city: "Flint",
                                  county: "Genesee",
                                  state: "MI",
                                  zip: "48480"),
           properties: ["rental"],
           previously_received_assistance: "yes",
           living_situation: "temporary_address",
           income_changed: "yes",
           income_changed_explanation: "I lost my job.",
           authorized_representative: "yes",
           authorized_representative_name: "Trusty McTrusterson",
           authorized_representative_phone: "2024561111",
           signature: "Octopus Cuttlefish",
           signed_at: DateTime.new(2018, 4, 1))
      end

      let(:attributes) do
        AssistanceApplicationForm.new(common_application).attributes
      end

      it "returns a hash with basic information" do
        expect(attributes).to include(
          applying_for_food: "Yes",
          applying_for_healthcare: "Yes",
          first_member_requesting_food: Integrated::PdfAttributes::UNDERLINED,
          first_member_requesting_healthcare: Integrated::PdfAttributes::UNDERLINED,
          legal_name: "Octopus Cuttlefish",
          dob: "10/18/1991",
          ssn: "123-45-6789",
          received_assistance: "Yes",
          is_homeless: "Yes",
          residential_address_street: "123 Main St",
          residential_address_apt: "Apt B",
          residential_address_city: "Flint",
          residential_address_county: "Genesee",
          residential_address_state: "MI",
          residential_address_zip: "48480",
          mailing_address: "456 Mailing Ave, Suite 500, Flint, MI 48480",
          first_member_dob: "10/18/1991",
          first_member_male: Integrated::PdfAttributes::CIRCLED,
          first_member_female: nil,
          first_member_married_yes: Integrated::PdfAttributes::CIRCLED,
          first_member_married_no: nil,
          first_member_citizen_yes: Integrated::PdfAttributes::CIRCLED,
          first_member_citizen_no: nil,
          anyone_in_college: "Yes",
          anyone_in_college_names: "Octopus Cuttlefish",
          anyone_disabled: "Yes",
          anyone_disabled_names: "Octopus Cuttlefish",
          anyone_a_veteran: "Yes",
          anyone_a_veteran_names: "Octopus Cuttlefish",
          anyone_recently_pregnant: "Yes",
          anyone_recently_pregnant_names: "Octopus Cuttlefish",
          anyone_medical_expenses: "Yes",
          medical_expenses_other: "Yes",
          first_member_medical_expenses_name: "Octopus Cuttlefish",
          first_member_medical_expenses_type: "Pregnancy-related",
          anyone_income_change: "Yes",
          anyone_income_change_explanation: "I lost my job.",
          anyone_employed: "Yes",
          first_member_employment_name: "Octopus Cuttlefish",
          anyone_self_employed: "Yes",
          first_member_self_employed_name: "Octopus Cuttlefish",
          anyone_additional_income: "Yes",
          additional_income_unemployment: "Yes",
          first_member_additional_income_name: "Octopus Cuttlefish",
          first_member_additional_income_type: "Unemployment",
          medical_expenses_health_insurance: "Yes",
          wants_authorized_representative: "Yes",
          authorized_representative_full_name: "Trusty McTrusterson",
          authorized_representative_phone_number: "(202) 456-1111",
          anyone_expenses_dependent_care: "Yes",
          dependent_care_childcare: "Yes",
          anyone_court_expenses: "Yes",
          court_expenses_child_support: "Yes",
          anyone_student_loans_deductions: "Yes",
          anyone_assets_property: "Yes",
          assets_property_rental: "Yes",
          completion_signature_applicant: "Octopus Cuttlefish",
          completion_signature_date: "04/01/2018",
        )
      end
    end

    context "an application with six members" do
      let(:common_application) do
        create(:common_application,
                        previously_received_assistance: "yes",
                        living_situation: "temporary_address",
                        members: [build(:household_member,
                                        first_name: "Willy",
                                        last_name: "Wells",
                                        pregnancy_expenses: "yes",
                                        healthcare_enrolled: "yes",
                                        flint_water: "yes",
                                        employments: [build(:employment)],
                                        self_employed: "yes",
                                        incomes: [build(:income, income_type: "unemployment")]),
                                  build(:household_member,
                                        first_name: "Willy",
                                        last_name: "Wiley",
                                        pregnancy_expenses: "yes",
                                        healthcare_enrolled: "yes",
                                        flint_water: "yes",
                                        employments: [build(:employment)],
                                        self_employed: "yes",
                                        incomes: [build(:income, income_type: "pension")]),
                                  build(:household_member,
                                        first_name: "Willy",
                                        last_name: "Wonka",
                                        pregnancy_expenses: "yes",
                                        healthcare_enrolled: "yes",
                                        employments: [build(:employment)],
                                        self_employed: "yes",
                                        incomes: [build(:income, income_type: "retirement"),
                                                  build(:income, income_type: "social_security")]),
                                  build(:household_member),
                                  build(:household_member),
                                  build(:household_member,
                                        first_name: "Willy",
                                        last_name: "Whale",
                                        relationship: "child",
                                        birthday: DateTime.new(1995, 10, 18),
                                        sex: "male",
                                        requesting_food: "yes",
                                        requesting_healthcare: "yes",
                                        healthcare_enrolled: "yes",
                                        married: "yes",
                                        citizen: "yes",
                                        flint_water: "yes")])
      end

      let(:attributes) do
        AssistanceApplicationForm.new(common_application).attributes
      end

      it "returns notes with different sections concatenated" do
        expect(attributes).to include(
          household_added_notes: "Yes",
        )
        expect(attributes[:notes]).to eq(
          <<~NOTES
            Additional Household Members:
            - Relation: Child, Legal name: Willy Whale, Sex: Male, DOB: 10/18/1995, Married: Yes, Citizen: Yes, Applying for: Food, Healthcare
            Additional Medical Expenses:
            - Willy Wonka, Pregnancy-related
            Additional Members Currently Enrolled in Health Coverage:
            - Willy Whale
            Additional Members Affected by the Flint Water Crisis:
            - Willy Whale
            Additional Employed Members:
            - Willy Wonka
            Additional Self-Employed Members:
            - Willy Wonka
            Additional Members with Additional Income:
            - Willy Wonka (Retirement, Social Security)
          NOTES
        )
      end
    end
  end
end
