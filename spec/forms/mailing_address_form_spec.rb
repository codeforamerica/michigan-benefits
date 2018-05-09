require "rails_helper"

RSpec.describe MailingAddressForm do
  describe "validations" do
    it "requires street address" do
      form = MailingAddressForm.new

      expect(form).not_to be_valid
      expect(form.errors[:street_address]).to be_present
    end

    it "requires city" do
      form = MailingAddressForm.new

      expect(form).not_to be_valid
      expect(form.errors[:city]).to be_present
    end

    it "requires zip" do
      form = MailingAddressForm.new

      expect(form).not_to be_valid
      expect(form.errors[:zip]).to be_present
    end

    it "requires zip to be 5-digit number" do
      alpha_form = MailingAddressForm.new(zip: "whaat")
      too_short_form = MailingAddressForm.new(zip: "123")

      expect(alpha_form).not_to be_valid
      expect(alpha_form.errors[:zip]).to be_present

      expect(too_short_form).not_to be_valid
      expect(too_short_form.errors[:zip]).to be_present
    end

    it "is valid with required fields" do
      form = MailingAddressForm.new(
        street_address: "1234 Fake St",
        city: "Pleasanton",
        zip: "12345",
      )

      expect(form).to be_valid
    end
  end
end
