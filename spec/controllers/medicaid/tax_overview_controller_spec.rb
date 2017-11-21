require "rails_helper"

RSpec.describe Medicaid::TaxOverviewController do
  describe "#skip" do
    it "is false if has any dependents" do
      medicaid_application = create(:medicaid_application)
      build(:member, benefit_application: medicaid_application)
      create(
        :member,
        claimed_as_dependent: true,
        benefit_application: medicaid_application,
      )
      session[:medicaid_application_id] = medicaid_application.id

      expect(subject.skip?).to eq false
    end

    it "is true if single member household" do
      medicaid_application = create(:medicaid_application)
      build(:member, benefit_application: medicaid_application)
      session[:medicaid_application_id] = medicaid_application.id

      expect(subject.skip?).to eq true
    end

    context "multi-member household" do
      it "is false when filing taxes with household members" do
        medicaid_application = create(
          :medicaid_application,
          filing_federal_taxes_next_year: true,
          filing_taxes_with_household_members: true,
        )
        build_list(:member, 2, benefit_application: medicaid_application)
        session[:medicaid_application_id] = medicaid_application.id

        expect(subject.skip?).to eq false
      end

      it "is true when not filing taxes" do
        medicaid_application = create(
          :medicaid_application,
          filing_federal_taxes_next_year: false,
          filing_taxes_with_household_members: true,
        )
        build_list(:member, 2, benefit_application: medicaid_application)
        session[:medicaid_application_id] = medicaid_application.id

        expect(subject.skip?).to eq true
      end

      it "is true when not filing taxes with a household member" do
        medicaid_application = create(
          :medicaid_application,
          filing_federal_taxes_next_year: true,
          filing_taxes_with_household_members: false,
        )
        build_list(:member, 2, benefit_application: medicaid_application)
        session[:medicaid_application_id] = medicaid_application.id

        expect(subject.skip?).to eq true
      end

      it "is true if not filing federal taxes next year" do
        medicaid_application = create(:medicaid_application)
        build_list(:member, 2, benefit_application: medicaid_application)
        session[:medicaid_application_id] = medicaid_application.id
      end
    end
  end
end
