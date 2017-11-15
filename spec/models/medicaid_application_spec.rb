require "rails_helper"

RSpec.describe MedicaidApplication do
  describe "#tax_filing_status" do
    context "filing taxes with household members" do
      it "is 'Joint'" do
        app = create(
          :medicaid_application,
          filing_federal_taxes_next_year: true,
          filing_taxes_with_household_members: true,
        )

        expect(app.tax_filing_status).to eq "Joint"
      end
    end

    context "not filing taxes with household members" do
      it "is 'Single'" do
        app = create(
          :medicaid_application,
          filing_federal_taxes_next_year: false,
          filing_taxes_with_household_members: false,
        )

        expect(app.tax_filing_status).to eq "Single"
      end
    end
  end

  describe "#residential_address" do
    context "residential address not present" do
      it "returns NullAddress" do
        app = create(:medicaid_application)
        create(:mailing_address, benefit_application: app)

        expect(app.residential_address).to be_a NullAddress
      end

      context "residential address present" do
        it "returns residential address" do
          app = create(:medicaid_application)
          create(:mailing_address, benefit_application: app)
          residential_address = create(
            :residential_address,
            benefit_application: app,
          )

          expect(app.residential_address).to eq residential_address
        end
      end
    end
  end

  describe "#mailing_address" do
    context "mailing address exists" do
      it "returns mailing address" do
        app = create(:medicaid_application)
        mailing_address = create(:mailing_address, benefit_application: app)

        expect(app.mailing_address).to eq(mailing_address)
      end
    end

    context "mailing address does not exist" do
      it "returns NullAddress" do
        app = create(:medicaid_application)
        create(:residential_address, benefit_application: app)

        expect(app.mailing_address.class).to eq(NullAddress)
      end
    end
  end

  describe "#no_expenses?" do
    it "returns false if anyone is self employed" do
      app = create(
        :medicaid_application,
        anyone_self_employed: true,
        anyone_pay_child_support_alimony_arrears: false,
        anyone_pay_student_loan_interest: false,
      )

      expect(app.no_expenses?).to eq(false)
    end

    it "returns false if anyone pays child support" do
      app = create(
        :medicaid_application,
        anyone_self_employed: false,
        anyone_pay_child_support_alimony_arrears: true,
        anyone_pay_student_loan_interest: false,
      )

      expect(app.no_expenses?).to eq(false)
    end

    it "returns false if anyone pays student loan interest" do
      app = create(
        :medicaid_application,
        anyone_employed: false,
        anyone_pay_child_support_alimony_arrears: false,
        anyone_pay_student_loan_interest: true,
      )

      expect(app.no_expenses?).to eq(false)
    end

    it "returns true if no expenses" do
      app = create(
        :medicaid_application,
        anyone_self_employed: false,
        anyone_pay_child_support_alimony_arrears: false,
        anyone_pay_student_loan_interest: false,
      )

      expect(app.no_expenses?).to eq(true)
    end
  end
end
