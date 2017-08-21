# frozen_string_literal: true

require "rails_helper"

RSpec.describe ResidentialAddress do
  context "client does not have a stable address" do
    it "validates address, city, and zip" do
      valid_residential_address = ResidentialAddress.new(
        street_address: nil,
        city: nil,
        zip: nil,
        county: "Genesee",
        state: "MI",
        unstable_housing: "1",
      )

      expect(valid_residential_address).to be_valid
    end
  end

  context "client has a stable address" do
    it "validates address, city, and zip" do
      valid_residential_address = ResidentialAddress.new(
        street_address: "123 Main St.",
        city: "Flint",
        zip: "12345",
        county: "Genesee",
        state: "MI",
        unstable_housing: "0",
      )

      invalid_nil_address = ResidentialAddress.new(
        street_address: nil,
        city: nil,
        zip: nil,
        county: "Genesee",
        state: "MI",
        unstable_housing: "0",
      )

      invalid_blank_address = ResidentialAddress.new(
        street_address: "",
        city: "",
        zip: "",
        county: "Genesee",
        state: "MI",
        unstable_housing: "0",
      )

      expect(valid_residential_address).to be_valid
      expect(invalid_nil_address).not_to be_valid
      expect(invalid_blank_address).not_to be_valid
    end
  end
end
