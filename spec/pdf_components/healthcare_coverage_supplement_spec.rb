require "rails_helper"

RSpec.describe HealthcareCoverageSupplement do
  describe "pdf component" do
    let(:subject) do
      HealthcareCoverageSupplement.new(double("fake application"))
    end

    it_should_behave_like "pdf component"
  end

  describe "#fill?" do
    it "responds to fill? and returns true" do
      form = HealthcareCoverageSupplement.new(double("fake application"))
      expect(form.fill?).to be_truthy
    end
  end

  describe "#attributes" do
    let(:attributes) do
      common_application = create(:common_application, members: [
                                    build(:household_member,
                                      requesting_healthcare: "yes",
                                      filing_taxes_next_year: "yes",
                                      first_name: "Julie",
                                      last_name: "Tester"),
                                    build(:household_member,
                                      first_name: "Jonny",
                                      last_name: "Tester",
                                      requesting_food: "yes",
                                      tax_relationship: "married_filing_jointly"),
                                    build(:household_member,
                                      first_name: "Jimmy",
                                      last_name: "Tester",
                                      requesting_food: "yes",
                                      tax_relationship: "dependent"),
                                  ])
      HealthcareCoverageSupplement.new(common_application).attributes
    end

    it "returns a hash with basic information" do
      expect(attributes).to include(
        anyone_filing_taxes: "Yes",
        filing_taxes_primary_filer_name: "Julie Tester",
        primary_filer_filing_jointly: "Yes",
        primary_filer_filing_jointly_spouse_name: "Jonny Tester",
        primary_filer_claiming_dependents: "Yes",
        primary_filer_claiming_dependents_dependents_names: "Jimmy Tester",
      )
    end
  end
end
