require "rails_helper"

RSpec.describe Medicaid::ContactResidentialNoMailAddress do
  describe "Validations" do
    it "validates presence of address fields" do
      valid_address = Medicaid::ContactResidentialNoMailAddress.new(
        residential_street_address: "123 Main St.",
        residential_city: "Flint",
        residential_zip: "12345",
      )

      invalid_nil_address = Medicaid::ContactResidentialNoMailAddress.new(
        residential_street_address: nil,
        residential_city: nil,
        residential_zip: nil,
      )

      invalid_blank_address = Medicaid::ContactResidentialNoMailAddress.new(
        residential_street_address: "",
        residential_city: "",
        residential_zip: "",
      )

      expect(valid_address).to be_valid
      expect(invalid_nil_address).not_to be_valid
      expect(invalid_blank_address).not_to be_valid
    end
  end
end
