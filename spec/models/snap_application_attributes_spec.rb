require "rails_helper"

RSpec.describe SnapApplicationAttributes do
  describe "#to_h" do
    it "returns a hash of attributes" do
      mailing_address = create(:mailing_address)
      residential_address = create(:address)
      snap_application = create(
        :snap_application,
        :with_member,
        addresses: [mailing_address, residential_address],
        financial_accounts: [:four_oh_one_k],
      )

      data =
        SnapApplicationAttributes.new(snap_application: snap_application).to_h

      expect(data).to eq(
        applying_for_food_assistance: "Yes",
        birth_day: "18",
        birth_month: "08",
        birth_year: "1990",
        email: "test@example.com",
        mailing_address_city: "Flint",
        mailing_address_county: "Genesee",
        mailing_address_state: "MI",
        mailing_address_street_address: "123 Main St.",
        mailing_address_zip: "12345",
        members_buy_food_with_no: "Yes",
        members_buy_food_with_yes: nil,
        members_not_buy_food_with: "",
        phone_number: nil,
        residential_address_city: nil,
        residential_address_county: nil,
        residential_address_state: nil,
        residential_address_street_address: nil,
        residential_address_zip: "12345",
        signature: "Mr. RJD2",
        signature_date: snap_application.signed_at.to_s,
        total_money: snap_application.total_money,
        monthly_gross_income: snap_application.monthly_gross_income,
        financial_accounts_checking_or_savings_account: false,
        financial_accounts_life_insurance: false,
        financial_accounts_other: false,
        financial_accounts_mutual_funds_or_stocks: false,
        financial_accounts_for_oh_one_k_or_iras: true,
        vehicle_income_yes: nil,
        vehicle_income_no: "Yes",
        self_employed_household_members_yes: nil,
        self_employed_household_members_no: "Yes",
        employed_household_members_yes: nil,
        employed_household_members_no: "Yes",
      )
    end
  end
end
