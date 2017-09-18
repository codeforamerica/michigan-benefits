require "rails_helper"

RSpec.describe OfficeRecipient do
  describe "#office" do
    before { stub_const("ENV", "APP_RELEASE_STAGE" => "production") }

    context "office location is present" do
      it "priotizes to office location over residential address" do
        application = app(from_zip_covered_by: :clio, office_location: "union")
        fax_recipient = described_class.new(snap_application: application)

        expect(fax_recipient.office).to eq(
          "email" => "MDHHS-Genesee-UnionSt-DigitalAssisterApp@michigan.gov",
          "name" => "Union",
          "fax_number" => union_fax_number,
        )
      end
    end

    it "uses the real fax number when the address is in clio" do
      fax_recipient = described_class.new(
        snap_application: app(from_zip_covered_by: :clio),
      )

      expect(fax_recipient.office).to eq(
        "email" => "MDHHS-Genesee-Clio-App@michigan.gov",
        "name" => "Clio",
        "fax_number" => clio_fax_number,
      )
    end

    it "uses the real fax number when the address is in union" do
      fax_recipient = described_class.new(
        snap_application: app(from_zip_covered_by: :union),
      )

      expect(fax_recipient.office).to eq(
        "email" => "MDHHS-Genesee-UnionSt-DigitalAssisterApp@michigan.gov",
        "name" => "Union",
        "fax_number" => union_fax_number,
      )
    end

    it "falls back to the clio office" do
      fax_recipient = described_class.new(
        snap_application: app(from_zip_covered_by: :nobody),
      )

      expect(fax_recipient.office).to eq(
        "email" => "MDHHS-Genesee-Clio-App@michigan.gov",
        "name" => "Clio",
        "fax_number" => clio_fax_number,
      )
    end

    it "allows for testing via zip 12345" do
      fax_recipient = described_class.new(
        snap_application: app(from_zip_covered_by: :testing),
      )

      expect(fax_recipient.office).to eq(
        "email" => "gcfengineering+heroku@codeforamerica.org",
        "name" => "Staging Sfax",
        "fax_number" => staging_fax_number,
      )
    end
  end

  describe "#number" do
    it "is whatever the office number is" do
      fax_recipient = described_class.new(
        snap_application: app(from_zip_covered_by: :testing),
      )

      expect(fax_recipient.number).to eq fax_recipient.office["fax_number"]
    end
  end

  describe "#name" do
    it "is whatever the office name is" do
      fax_recipient = described_class.new(
        snap_application: app(from_zip_covered_by: :testing),
      )

      expect(fax_recipient.name).to eq fax_recipient.office["name"]
    end
  end

  def clio_fax_number
    "+18107602310"
  end

  def union_fax_number
    "+18107607372"
  end

  def staging_fax_number
    "+18888433549"
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
