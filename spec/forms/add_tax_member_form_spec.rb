require "rails_helper"

RSpec.describe AddTaxMemberForm do
  describe "validations" do
    it "requires tax_relationship" do
      form = AddTaxMemberForm.new

      expect(form).not_to be_valid
      expect(form.errors[:tax_relationship]).to be_present
    end
  end
end
