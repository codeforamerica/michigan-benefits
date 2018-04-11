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
          requesting_food: "yes",
          requesting_healthcare: "yes",
          married: "yes",
          student: "yes",
          disabled: "yes",
          citizen: "yes",
          veteran: "yes",
          pregnant: "no",
          pregnancy_expenses: "yes",
          job_count: 1,
          self_employed: "yes")
      end

      let(:common_application) do
        create(:common_application,
           members: [primary_member],
           previously_received_assistance: "yes",
           living_situation: "temporary_address",
           income_changed: "yes",
           income_changed_explanation: "I lost my job.")
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
          received_assistance: "Yes",
          is_homeless: "Yes",
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
                                        job_count: 1,
                                        self_employed: "yes"),
                                  build(:household_member,
                                        first_name: "Willy",
                                        last_name: "Wiley",
                                        pregnancy_expenses: "yes",
                                        healthcare_enrolled: "yes",
                                        flint_water: "yes",
                                        job_count: 1,
                                        self_employed: "yes"),
                                  build(:household_member,
                                        first_name: "Willy",
                                        last_name: "Wonka",
                                        pregnancy_expenses: "yes",
                                        healthcare_enrolled: "yes",
                                        job_count: 1,
                                        self_employed: "yes"),
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
          NOTES
        )
      end
    end
  end

  describe "defaults in pdf" do
    it "returns default fields from pdf" do
      fields = PdfForms.new.get_fields(AssistanceApplicationForm.new(double("fake application")).source_pdf_path)

      data = {}
      fields.each_with_object(data) do |field, hash|
        hash[field.name] = field.value
      end
      expect(AssistanceApplicationForm::DEFAULTS).to eq(data)
    end
  end
end
