require "rails_helper"

RSpec.describe OfficeRecipient do
  describe "#office" do
    before do
      allow(GateKeeper).
        to receive(:application_routing_environment) { "production" }
    end

    context "medicaid app" do
      it "finds the office without raising an error" do
        application = double(
          residential_zip: OFFICE_TO_ZIP_MAPPING[:clio],
          office_location: nil,
        )
        recipent = described_class.new(benefit_application: application)

        expect(recipent.office).to eq(
          "email" => "MDHHS-Genesee-Clio-App@michigan.gov",
          "name" => "Clio",
          "phone_number" => clio_phone_number,
        )
      end
    end

    context "office location is present" do
      it "prioritizes to office location over residential address" do
        application = app(from_zip_covered_by: :clio, office_location: "union")
        recipent = described_class.new(benefit_application: application)

        expect(recipent.office).to eq(
          "email" => "MDHHS-Genesee-UnionSt-DigitalAssisterApp@michigan.gov",
          "name" => "Union",
          "phone_number" => union_phone_number,
        )
      end
    end

    it "falls back to the clio office" do
      recipent = described_class.new(
        benefit_application: app(from_zip_covered_by: :nobody),
      )

      expect(recipent.office).to eq(
        "email" => "MDHHS-Genesee-Clio-App@michigan.gov",
        "name" => "Clio",
        "phone_number" => clio_phone_number,
      )
    end

    it "allows for testing via zip 12345" do
      recipent = described_class.new(
        benefit_application: app(from_zip_covered_by: :testing),
      )

      expect(recipent.office).to eq(
        "email" => "hello@michiganbenefits.org",
        "name" => "Test Office",
        "phone_number" => test_office_phone_number,
      )
    end
  end

  describe "#name" do
    it "is whatever the office name is" do
      recipent = described_class.new(
        benefit_application: app(from_zip_covered_by: :testing),
      )

      expect(recipent.name).to eq recipent.office["name"]
    end
  end

  def clio_phone_number
    "8107877101"
  end

  def union_phone_number
    "8107607300"
  end

  def test_office_phone_number
    "2024561111"
  end

  OFFICE_TO_ZIP_MAPPING = {
    union: 48411,
    clio: 48415,
    nobody: 98765,
    testing: 12345,
  }.freeze

  def app(from_zip_covered_by:, office_location: nil)
    double(
      residential_address: double(
        zip: OFFICE_TO_ZIP_MAPPING[from_zip_covered_by],
      ),
      office_location: office_location,
    )
  end
end
