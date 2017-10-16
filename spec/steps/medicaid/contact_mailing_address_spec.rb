require "rails_helper"

RSpec.describe Medicaid::ContactMailingAddress do
  describe "Validations" do
    it "validates presence of address fields" do
      valid_address = Medicaid::ContactMailingAddress.new(
        mailing_street_address: "123 Main St.",
        mailing_city: "Flint",
        mailing_zip: "12345",
      )

      invalid_nil_address = Medicaid::ContactMailingAddress.new(
        mailing_street_address: nil,
        mailing_city: nil,
        mailing_zip: nil,
      )

      invalid_blank_address = Medicaid::ContactMailingAddress.new(
        mailing_street_address: "",
        mailing_city: "",
        mailing_zip: "",
      )

      expect(valid_address).to be_valid
      expect(invalid_nil_address).not_to be_valid
      expect(invalid_blank_address).not_to be_valid
    end
  end
end
