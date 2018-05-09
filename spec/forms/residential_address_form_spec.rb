require "rails_helper"

RSpec.describe ResidentialAddressForm do
  describe "validations" do
    it "is invalid without required fields" do
      form = ResidentialAddressForm.new

      expect(form).not_to be_valid
      expect(form.errors["street_address"]).to be_present
      expect(form.errors["city"]).to be_present
      expect(form.errors["zip"]).to be_present
    end

    it "requires zip to be 5-digit number" do
      alpha_form = ResidentialAddressForm.new(zip: "whaat")
      too_short_form = ResidentialAddressForm.new(zip: "123")

      expect(alpha_form).not_to be_valid
      expect(alpha_form.errors[:zip]).to be_present

      expect(too_short_form).not_to be_valid
      expect(too_short_form.errors[:zip]).to be_present
    end

    it "is valid with required fields" do
      form = ResidentialAddressForm.new(
        street_address: "1234 Fake St",
        city: "Pleasanton",
        zip: "12345",
      )

      expect(form).to be_valid
    end
  end
end
