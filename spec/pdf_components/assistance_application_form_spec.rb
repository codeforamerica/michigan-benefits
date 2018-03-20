require "spec_helper"
require_relative "../../app/models/concerns/pdf_attributes"
require_relative "../support/shared_examples/pdf_component"
require_relative "../../app/models/null_address"
require_relative "../../app/pdf_components/assistance_application_form"

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
        instance_double("household_member",
          display_name: "Octopus Cuttlefish",
          relationship_label: "You",
          birthday: DateTime.new(1991, 10, 18),
          sex_male?: true,
          sex_female?: false,
          requesting_food_yes?: true,
          requesting_healthcare_yes?: true,
        )
      end

      let(:common_application) do
        instance_double("common_application",
          display_name: "Octopus Cuttlefish",
          previously_received_assistance_yes?: true,
          previously_received_assistance_no?: false,
          temporary_address?: true,
          homeless?: false,
          stable_address?: false,
          primary_member: primary_member,
          members: [primary_member])
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
        )
      end
    end

    context "an application with six members" do
      let(:primary_member) do
        instance_double("household_member",
                        display_name: "Octopus Cuttlefish",
                        relationship_label: "You",
                        birthday: DateTime.new(1991, 10, 18),
                        sex_male?: true,
                        sex_female?: false,
                        requesting_food_yes?: true,
                        requesting_healthcare_yes?: true)
      end

      let(:common_application) do
        instance_double("common_application",
                        display_name: "Octopus Cuttlefish",
                        previously_received_assistance_yes?: true,
                        previously_received_assistance_no?: false,
                        temporary_address?: true,
                        homeless?: false,
                        stable_address?: false,
                        primary_member: primary_member,
                        members: [primary_member,
                                  instance_double("household_member",
                                    display_name: "Tuna Anemone",
                                    relationship_label: "Spouse",
                                    birthday: DateTime.new(1991, 10, 18),
                                    sex_male?: true,
                                    sex_female?: false,
                                    requesting_food_yes?: true,
                                    requesting_healthcare_yes?: false),
                                  instance_double("household_member",
                                    display_name: "Coral Eel",
                                    relationship_label: "Parent",
                                    birthday: DateTime.new(1991, 10, 18),
                                    sex_male?: true,
                                    sex_female?: false,
                                    requesting_food_yes?: true,
                                    requesting_healthcare_yes?: false),
                                  instance_double("household_member",
                                    display_name: "Snail Squid",
                                    relationship_label: "Parent",
                                    birthday: DateTime.new(1991, 10, 18),
                                    sex_male?: true,
                                    sex_female?: false,
                                    requesting_food_yes?: true,
                                    requesting_healthcare_yes?: false),
                                  instance_double("household_member",
                                    display_name: "Flounder Halibut",
                                    relationship_label: "Sibling",
                                    birthday: DateTime.new(1991, 10, 18),
                                    sex_male?: true,
                                    sex_female?: false,
                                    requesting_food_yes?: false,
                                    requesting_healthcare_yes?: false),
                                  instance_double("household_member",
                                    display_name: "Willy Whale",
                                    relationship_label: "Child",
                                    birthday: DateTime.new(1995, 10, 18),
                                    sex: "male",
                                    requesting_food_yes?: true,
                                    requesting_healthcare_yes?: true)])
      end

      let(:attributes) do
        AssistanceApplicationForm.new(common_application).attributes
      end

      it "returns a hash with basic information" do
        expect(attributes).to include(
          first_member_legal_name: "Octopus Cuttlefish",
          first_member_dob: "10/18/1991",
          first_member_male: Integrated::PdfAttributes::CIRCLED,
          first_member_female: nil,
          second_member_legal_name: "Tuna Anemone",
          second_member_relation: "Spouse",
          second_member_dob: "10/18/1991",
          second_member_male: Integrated::PdfAttributes::CIRCLED,
          second_member_female: nil,
          third_member_legal_name: "Coral Eel",
          third_member_relation: "Parent",
          third_member_dob: "10/18/1991",
          third_member_male: Integrated::PdfAttributes::CIRCLED,
          third_member_female: nil,
          fourth_member_legal_name: "Snail Squid",
          fourth_member_relation: "Parent",
          fourth_member_dob: "10/18/1991",
          fourth_member_male: Integrated::PdfAttributes::CIRCLED,
          fourth_member_female: nil,
          fifth_member_legal_name: "Flounder Halibut",
          fifth_member_relation: "Sibling",
          fifth_member_dob: "10/18/1991",
          fifth_member_male: Integrated::PdfAttributes::CIRCLED,
          fifth_member_female: nil,
          household_added_notes: "Yes",
        )
        expect(attributes[:notes]).to eq(
          <<~NOTES
            Additional Household Members:
            - Relation: Child, Legal name: Willy Whale, Sex: Male, DOB: 10/18/1995, Applying for: Food, Healthcare
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
