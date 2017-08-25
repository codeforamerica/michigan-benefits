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
        bool_to_checkbox(any_members_not_buy_food_with?),
      members_buy_food_with_yes:
        bool_to_checkbox(all_members_buy_food_with?),
      members_not_buy_food_with: members_not_buy_food_with,
      homeless: bool_to_checkbox(snap_application.unstable_housing?),
      residential_address_city: snap_application.residential_address.city,
      residential_address_county: snap_application.residential_address.county,
      residential_address_state: snap_application.residential_address.state,
      residential_address_street_address: residential_or_homeless,
      residential_address_zip: snap_application.mailing_address.zip,
      signature: snap_application.signature,
      signature_date: snap_application.signed_at,
      monthly_rent_taxes_and_insurance: monthly_rent_taxes_and_insurance,
      total_money: snap_application.total_money,
      monthly_gross_income: snap_application.monthly_gross_income,
      members_with_disability_no:
        bool_to_checkbox(!snap_application.anyone_disabled?),
      first_member_with_disability_name: first_member_with_disability_name,
      second_member_with_disability_name: second_member_with_disability_name,
      third_member_with_disability_name: third_member_with_disability_name,
      financial_accounts_checking_or_savings_account:
        financial_accounts(:checking_account, :savings_account),
      financial_accounts_trusts: financial_accounts(:trusts),
      financial_accounts_life_insurance: financial_accounts(:life_insurnace),
      financial_accounts_other: financial_accounts(:other),
      financial_accounts_mutual_funds_or_stocks:
        financial_accounts(:mutual_funds, :stocks),
      financial_accounts_four_oh_one_k_or_iras:
        financial_accounts(:four_oh_one_k, :iras),
      monthly_additional_income: snap_application.monthly_additional_income,
      vehicle_income_yes: bool_to_checkbox(snap_application.vehicle_income?),
      vehicle_income_no: bool_to_checkbox(!snap_application.vehicle_income?),
      income_change_yes: bool_to_checkbox(snap_application.income_change?),
      income_change_no: bool_to_checkbox(!snap_application.income_change?),
      income_change_explanation: snap_application.income_change_explanation,
      more_than_two_self_employed_yes:
        bool_to_checkbox(self_employed_household_members.length > 2),
      more_than_two_self_employed_no:
        bool_to_checkbox(self_employed_household_members.length <= 2),
      self_employed_household_members_yes:
        bool_to_checkbox(self_employed_household_members.any?),
      self_employed_household_members_no:
        bool_to_checkbox(self_employed_household_members.empty?),
      more_than_two_employed_yes:
        bool_to_checkbox(employed_household_members.length > 2),
      more_than_two_employed_no:
        bool_to_checkbox(employed_household_members.length <= 2),
      employed_household_members_yes:
        bool_to_checkbox(employed_household_members.any?),
      employed_household_members_no:
        bool_to_checkbox(employed_household_members.empty?),
      additional_income_yes:
        bool_to_checkbox(snap_application.additional_income.any?),
      additional_income_no:
        bool_to_checkbox(snap_application.additional_income.empty?),
      additional_income_social_security: additional_income?("social_security"),
      additional_income_pension: additional_income?("pension"),
      additional_income_unemployment:
        additional_income?("unemployment_insurance"),
      additional_income_ssi: additional_income?("ssi_or_disability"),
      additional_income_workers_compensation:
        additional_income?("workers_compensation"),
      additional_income_child_support: additional_income?("child_support"),
      additional_income_other: additional_income?("other"),
      court_ordered_expenses_child_support:
        court_ordered_expense?("child_support"),
      court_ordered_expenses_alimony: court_ordered_expense?("alimony"),
      court_ordered_expenses_yes:
        bool_to_checkbox(snap_application.court_ordered?),
      court_ordered_expenses_no:
        bool_to_checkbox(!snap_application.court_ordered?),
      monthly_court_ordered_expenses:
        snap_application.monthly_court_ordered_expenses,
      medical_expenses_yes: bool_to_checkbox(snap_application.medical?),
      medical_expenses_no: bool_to_checkbox(!snap_application.medical?),
      medical_expenses_health_insurance: medical_expense?("health_insurance"),
      medical_expenses_prescriptions: medical_expense?("prescriptions"),
      medical_expenses_dental: medical_expense?("dental"),
      medical_expenses_transportation: medical_expense?("transportation"),
      medical_expenses_hospital_bills: medical_expense?("hospital_bills"),
      medical_expenses_other: other_medical_expense?,
      monthly_medical_expenses: snap_application.monthly_medical_expenses,
      dependent_care_yes: bool_to_checkbox(snap_application.dependent_care?),
      dependent_care_no: bool_to_checkbox(!snap_application.dependent_care?),
      care_expenses_childcare: care_expense?("childcare"),
      care_expenses_disabled: care_expense?("disabled_adult_care"),
      monthly_care_expenses: snap_application.monthly_care_expenses,
      rent_expense_yes: rent_expense_yes,
      rent_expense: rent_expense,
      mortgage_expense_yes: mortgage_expense_yes,
      mortgage_expense: mortgage_expense,
      property_tax_expense_yes:
        bool_to_checkbox(snap_application.property_tax_expense.present?),
      annual_property_tax_expense: annual_property_tax_expense,
      annual_insurance_expense: annual_insurance_expense,
      insurance_expense_yes:
        bool_to_checkbox(snap_application.insurance_expense.present?),
      utility_heat: bool_to_checkbox(snap_application.utility_heat?),
      utility_heat_no: bool_to_checkbox(!snap_application.utility_heat?),
      utility_cooling: bool_to_checkbox(snap_application.utility_cooling?),
      utility_cooling_no:
        bool_to_checkbox(!snap_application.utility_cooling?),
      utility_electricity:
        bool_to_checkbox(snap_application.utility_electrity?),
      utility_water_sewer:
        bool_to_checkbox(snap_application.utility_water_sewer?),
      utility_trash: bool_to_checkbox(snap_application.utility_trash?),
      utility_phone: bool_to_checkbox(snap_application.utility_phone?),
      utility_other: bool_to_checkbox(snap_application.utility_other?),
    }.merge(phone_attributes).symbolize_keys
  end

  private

  attr_reader :snap_application

  def primary_member
    @_primary_member ||= snap_application.primary_member
  end

  def bool_to_checkbox(statement)
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

  def phone_attributes
    if snap_application.phone_number.nil?
      {}
    else
      ten_digit_phone.each_with_index.reduce({}) do |memo, (phone_digit, index)|
        memo["phone_number_#{index}"] = phone_digit
        memo
      end
    end
  end

  def ten_digit_phone
    snap_application.phone_number.split("").last(10)
  end

  def monthly_rent_taxes_and_insurance
    [
      snap_application.rent_expense,
      snap_application.property_tax_expense,
      snap_application.insurance_expense,
    ].compact.reduce(:+)
  end

  def first_member_with_disability_name
    disabled_members[0].try(:full_name)
  end

  def second_member_with_disability_name
    disabled_members[1].try(:full_name)
  end

  def third_member_with_disability_name
    disabled_members[2].try(:full_name)
  end

  def disabled_members
    @_disabled_members ||= snap_application.members.where(disabled: true)
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

  def additional_income?(type)
    bool_to_checkbox(snap_application.additional_income.include?(type))
  end

  def medical_expense?(type)
    bool_to_checkbox(snap_application.medical_expenses.include?(type))
  end

  def other_medical_expense?
    included = ["other", "co_pays", "in_home_care"].select do |expense|
      snap_application.medical_expenses.include?(expense)
    end

    bool_to_checkbox(included.any?)
  end

  def court_ordered_expense?(type)
    bool_to_checkbox(snap_application.court_ordered_expenses.include?(type))
  end

  def care_expense?(type)
    bool_to_checkbox(snap_application.care_expenses.include?(type))
  end

  def annual_property_tax_expense
    if snap_application.property_tax_expense
      snap_application.property_tax_expense * 12
    end
  end

  def annual_insurance_expense
    if snap_application.insurance_expense
      snap_application.insurance_expense * 12
    end
  end

  def rent_expense_yes
    if !homeowner?
      bool_to_checkbox(snap_application.rent_expense.present?)
    end
  end

  def mortgage_expense_yes
    if homeowner?
      bool_to_checkbox(snap_application.rent_expense.present?)
    end
  end

  def rent_expense
    if !homeowner?
      snap_application.rent_expense
    end
  end

  def mortgage_expense
    if homeowner?
      snap_application.rent_expense
    end
  end

  def homeowner?
    snap_application.insurance_expense.present? ||
      snap_application.property_tax_expense.present?
  end
end
