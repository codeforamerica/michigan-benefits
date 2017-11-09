require "rails_helper"

RSpec.describe Medicaid::ContactMailingAddress do
  describe "Validations" do
    it "validates presence of address fields" do
      valid_address = Medicaid::ContactMailingAddress.new(
        street_address: "123 Main St.",
        city: "Flint",
        zip: "12345",
      )

      invalid_nil_address = Medicaid::ContactMailingAddress.new(
        street_address: nil,
        city: nil,
        zip: nil,
      )

      invalid_blank_address = Medicaid::ContactMailingAddress.new(
        street_address: "",
        city: "",
        zip: "",
      )

      expect(valid_address).to be_valid
      expect(invalid_nil_address).not_to be_valid
      expect(invalid_blank_address).not_to be_valid
    end
  end
end
