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
    context "household filing taxes jointly" do
      let(:attributes) do
        common_application = create(:common_application, members: [
                                      build(:household_member,
                                        requesting_healthcare: "yes",
                                        filing_taxes_next_year: "yes",
                                        first_name: "Julie",
                                        last_name: "Tester",
                                        caretaker: "yes",
                                        healthcare_enrolled: "yes"),
                                      build(:household_member,
                                        first_name: "Jonny",
                                        last_name: "Tester",
                                        requesting_food: "yes",
                                        tax_relationship: "married_filing_jointly",
                                        caretaker: "yes",
                                        healthcare_enrolled: "yes"),
                                      build(:household_member,
                                        first_name: "Jimmy",
                                        last_name: "Tester",
                                        requesting_food: "yes",
                                        tax_relationship: "dependent",
                                        foster_care_at_18: "yes"),
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
          anyone_caretaker: "Yes",
          anyone_caretaker_names: "Julie Tester, Jonny Tester",
          anyone_fostercare_adult: "Yes",
          anyone_fostercare_adult_names: "Jimmy Tester",
          anyone_has_health_insurance: "Yes",
          first_member_has_health_insurance_name: "Julie Tester",
          second_member_has_health_insurance_name: "Jonny Tester",
        )
      end
    end

    context "household filing taxes separately" do
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
                                            tax_relationship: "married_filing_separately"),
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
          primary_filer_filing_jointly: "No",
          primary_filer_filing_jointly_spouse_name: nil,
          primary_filer_claiming_dependents: "Yes",
          primary_filer_claiming_dependents_dependents_names: "Jimmy Tester",
          filing_taxes_second_filer_name: "Jonny Tester",
          second_filer_filing_jointly: "No",
        )
      end
    end
  end
end
