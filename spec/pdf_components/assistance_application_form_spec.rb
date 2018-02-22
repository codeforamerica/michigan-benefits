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
    let(:common_application) do
      double(
        :common_application,
        display_name: "Octopus Cuttlefish",
      )
    end

    subject do
      AssistanceApplicationForm.new(common_application).attributes
    end

    context "an application with one member" do
      it "returns a hash with basic information" do
        expect(subject).to include(
          legal_name: "Octopus Cuttlefish",
        )
      end
    end
  end
end
