require "rails_helper"

RSpec.describe Integrated::ReviewTaxHouseholdController do
  describe "#skip?" do
    context "when primary member is not applying for healthcare" do
      it "returns true" do
        application = create(:common_application, members: [create(:household_member, requesting_healthcare: "no")])

        skip_step = Integrated::ReviewTaxHouseholdController.skip?(application)
        expect(skip_step).to eq(true)
      end
    end

    context "when primary member is applying for healthcare" do
      context "when applicant is not filing taxes next year" do
        it "returns true" do
          application = create(:common_application, members: [
                                 create(:household_member, requesting_healthcare: "yes", filing_taxes_next_year: "no"),
                               ])

          skip_step = Integrated::ReviewTaxHouseholdController.skip?(application)
          expect(skip_step).to eq(true)
        end
      end

      context "when applicant is filing taxes next year" do
        it "returns false" do
          application = create(:common_application, members: [
                                 create(:household_member, requesting_healthcare: "yes", filing_taxes_next_year: "yes"),
                               ])

          skip_step = Integrated::ReviewTaxHouseholdController.skip?(application)
          expect(skip_step).to be_falsey
        end
      end
    end
  end
end
