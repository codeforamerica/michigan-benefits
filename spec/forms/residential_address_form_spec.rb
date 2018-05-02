require "rails_helper"

RSpec.describe ResidentialAddressForm do
  describe "validations" do
    it "requires some attribute" do
      form = ResidentialAddressForm.new

      expect(form).not_to be_valid
      expect(form.errors["street_address"]).to be_present
      expect(form.errors["city"]).to be_present
      expect(form.errors["zip"]).to be_present
    end
  end
end
