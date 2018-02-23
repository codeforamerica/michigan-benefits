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
    let(:primary_member) do
      instance_double("household_member",
        birthday: DateTime.new(1991, 10, 18),
        sex_male?: true,
        sex_female?: false)
    end

    let(:common_application) do
      instance_double("common_application",
        display_name: "Octopus Cuttlefish",
        primary_member: primary_member)
    end

    subject do
      AssistanceApplicationForm.new(common_application).attributes
    end

    context "an application with one member" do
      it "defaults to requesting food" do
        expect(subject).to include(
          applying_for_food: "Yes",
          first_member_requesting_food: PdfAttributes::UNDERLINED,
        )
      end

      it "returns a hash with basic information" do
        expect(subject).to include(
          legal_name: "Octopus Cuttlefish",
          first_member_dob: "10/18/1991",
          first_member_male: PdfAttributes::CIRCLED,
          first_member_female: nil,
        )
      end
    end
  end
end
