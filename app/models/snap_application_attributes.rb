class SnapApplicationAttributes
  def initialize(snap_application:)
    @snap_application = snap_application
  end

  def to_h
    {
      applying_for_food_assistance: "Yes",
      birth_day: primary_member.birthday.strftime("%d"),
      birth_month: primary_member.birthday.strftime("%m"),
      birth_year: primary_member.birthday.strftime("%Y"),
      email: snap_application.email,
      mailing_address_city: snap_application.mailing_address.city,
      mailing_address_county: snap_application.mailing_address.county,
      mailing_address_state: snap_application.mailing_address.state,
      mailing_address_street_address:
        snap_application.mailing_address.street_address,
      mailing_address_zip: snap_application.mailing_address.zip,
      members_buy_food_with_no:
        boolean_to_checkbox(any_members_not_buy_food_with?),
      members_buy_food_with_yes:
        boolean_to_checkbox(all_members_buy_food_with?),
      members_not_buy_food_with: members_not_buy_food_with,
      phone_number: snap_application.phone_number,
      residential_address_city: snap_application.residential_address.city,
      residential_address_county: snap_application.residential_address.county,
      residential_address_state: snap_application.residential_address.state,
      residential_address_street_address: residential_or_homeless,
      residential_address_zip: snap_application.mailing_address.zip,
      signature: snap_application.signature,
      signature_date: snap_application.signed_at,
      total_money: snap_application.total_money,
      monthly_gross_income: snap_application.monthly_gross_income,
      financial_accounts_checking_or_savings_account:
        financial_accounts(:checking_account, :savings_account),
      financial_accounts_life_insurance: financial_accounts(:life_insurnace),
      financial_accounts_other: financial_accounts(:other),
      financial_accounts_mutual_funds_or_stocks:
        financial_accounts(:mutual_funds, :stocks),
      financial_accounts_for_oh_one_k_or_iras:
        financial_accounts(:four_oh_one_k, :iras),
      vehicle_income_yes:
        boolean_to_checkbox(snap_application.vehicle_income?),
      vehicle_income_no: boolean_to_checkbox(!snap_application.vehicle_income?),
      self_employed_household_members_yes:
        boolean_to_checkbox(self_employed_household_members.any?),
      self_employed_household_members_no:
        boolean_to_checkbox(self_employed_household_members.empty?),
      employed_household_members_yes:
        boolean_to_checkbox(employed_household_members.any?),
      employed_household_members_no:
        boolean_to_checkbox(employed_household_members.empty?),
    }
  end

  private

  attr_reader :snap_application

  def primary_member
    @_primary_member ||= snap_application.primary_member
  end

  def boolean_to_checkbox(statement)
    if statement == true
      "Yes"
    end
  end

  def residential_or_homeless
    if snap_application.unstable_housing?
      "Homeless"
    else
      snap_application.residential_address.street_address
    end
  end

  def all_members_buy_food_with?
    !buy_food_with.include?(false)
  end

  def any_members_not_buy_food_with?
    buy_food_with.include?(false)
  end

  def buy_food_with
    snap_application.members.map(&:buy_food_with?)
  end

  def members_not_buy_food_with
    snap_application.
      members.
      where.
      not(buy_food_with: true).
      select('first_name || " " || last_name AS full_name').
      pluck(:first_name, :last_name).
      to_sentence
  end

  def financial_accounts(*types)
    included = [false]

    types.each do |type|
      if snap_application.financial_accounts.include?(type.to_s)
        included << true
      end
    end

    included.include?(true)
  end

  def self_employed_household_members
    @_self_employed_household_members ||=
      snap_application.members.where(employment_status: "self_employed")
  end

  def employed_household_members
    @_employed_household_members ||=
      snap_application.members.where(employment_status: "employed")
  end
end
