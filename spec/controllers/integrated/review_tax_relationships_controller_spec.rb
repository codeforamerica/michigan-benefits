require "rails_helper"

RSpec.describe Integrated::ReviewTaxRelationshipsController do
  describe "#skip?" do
    context "when applicant is not filing taxes next year" do
      it "returns true" do
        application = create(:common_application, members: [create(:household_member, filing_taxes_next_year: "no")])

        skip_step = Integrated::ReviewTaxRelationshipsController.skip?(application)
        expect(skip_step).to eq(true)
      end
    end
  end
end
