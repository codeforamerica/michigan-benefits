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
                                      requesting_food: "yes"),
                                  ])
      HealthcareCoverageSupplement.new(common_application).attributes
    end

    it "returns a hash with basic information" do
      expect(attributes).to include(
        anyone_filing_taxes: "Yes",
        filing_taxes_primary_filer_name: "Julie Tester",
      )
    end
  end
end
