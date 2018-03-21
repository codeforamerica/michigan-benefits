require "rails_helper"

RSpec.describe DescribeTaxRelationshipsForm do
  describe "validations" do
    it "requires a valid tax relationship for each member" do
      form = DescribeTaxRelationshipsForm.new(
        members: [build(:household_member)],
      )

      expect(form).not_to be_valid
    end
  end
end
