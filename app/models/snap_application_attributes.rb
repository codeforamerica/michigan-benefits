class SnapApplicationAttributes
  include PdfAttributes

  def initialize(snap_application:)
    @snap_application = snap_application
  end

  private

  attr_reader :snap_application

  def attributes
    [
      {
        applying_for_food_assistance: "Yes",
        email: snap_application.email,
        mailing_address_city: snap_application.mailing_address.city,
        mailing_address_county: snap_application.mailing_address.county,
        mailing_address_state: snap_application.mailing_address.state,
        mailing_address_street_address:
          full_street_address(snap_application.mailing_address),
        mailing_address_zip: snap_application.mailing_address.zip,
        members_not_buy_food_with: members_not_buy_food_with,
        residential_address_city: snap_application.residential_address.city,
        residential_address_county: snap_application.residential_address.county,
        residential_address_state: snap_application.residential_address.state,
        residential_address_street_address: residential_or_homeless,
        residential_address_zip: snap_application.mailing_address.zip,
        signature: snap_application.signature,
        signature_date: snap_application.signed_at_est,
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
        additional_income_social_security:
          additional_income?("social_security"),
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
        monthly_court_ordered_expenses:
          snap_application.monthly_court_ordered_expenses,
        court_ordered_expenses_interval: bool_to_checkbox(
          snap_application.monthly_court_ordered_expenses.present?,
        ),
        income_change_explanation: snap_application.income_change_explanation,
        medical_expenses_health_insurance: medical_expense?("health_insurance"),
        medical_expenses_prescriptions: medical_expense?("prescriptions"),
        medical_expenses_dental: medical_expense?("dental"),
        medical_expenses_transportation: medical_expense?("transportation"),
        medical_expenses_hospital_bills: medical_expense?("hospital_bills"),
        medical_expenses_other: other_medical_expense?,
        monthly_medical_expenses: snap_application.monthly_medical_expenses,
        care_expenses_childcare: care_expense?("childcare"),
        care_expenses_disabled: care_expense?("disabled_adult_care"),
        monthly_care_expenses: snap_application.monthly_care_expenses,
        care_expenses_interval: bool_to_checkbox(
          snap_application.monthly_care_expenses.present?,
        ),
        rent_expense_yes: rent_expense_yes,
        rent_expense: rent_expense,
        rent_expense_interval: bool_to_checkbox(rent_expense.present?),
        mortgage_expense_yes: mortgage_expense_yes,
        mortgage_expense: mortgage_expense,
        mortgage_expense_interval: bool_to_checkbox(mortgage_expense.present?),
        property_tax_expense_yes:
          bool_to_checkbox(annual_property_tax_expense.present?),
        annual_property_tax_expense: annual_property_tax_expense,
        annual_insurance_expense: annual_insurance_expense,
        insurance_expense_yes:
          bool_to_checkbox(annual_insurance_expense.present?),
        utility_electricity:
          bool_to_checkbox(snap_application.utility_electrity?),
        utility_water_sewer:
          bool_to_checkbox(snap_application.utility_water_sewer?),
        utility_trash: bool_to_checkbox(snap_application.utility_trash?),
        utility_phone: bool_to_checkbox(snap_application.utility_phone?),
        utility_other: bool_to_checkbox(snap_application.utility_other?),
        authorized_representative_name:
          snap_application.authorized_representative_name,
      },
      phone_attributes,
      yes_no_checkbox("homeless", !snap_application.stable_housing?),
      yes_no_checkbox(
        "authorized_representative",
        snap_application.authorized_representative,
      ),
      yes_no_checkbox("more_than_six_members", more_than_six_members_yes),
      yes_no_checkbox("dependent_care", snap_application.dependent_care?),
      yes_no_checkbox("medical_expenses", snap_application.medical?),
      yes_no_checkbox(
        "court_ordered_expenses",
        snap_application.court_ordered?,
      ),
      yes_no_checkbox(
        "employed_household_members",
        employed_household_members.any?,
      ),
      yes_no_checkbox(
        "additional_income",
        snap_application.additional_income.any?,
      ),
      yes_no_checkbox("vehicle_income", snap_application.vehicle_income?),
      yes_no_checkbox("income_change", snap_application.income_change?),
      yes_no_checkbox(
        "more_than_two_self_employed",
        more_than_two_self_employed_yes,
      ),
      yes_no_checkbox(
        "self_employed_household_members",
        self_employed_household_members.any?,
      ),
      yes_no_checkbox("more_than_two_employed", more_than_two_employed_yes),
      yes_no_checkbox("members_buy_food_with", all_members_buy_food_with?),
      yes_no_checkbox("utility_heat", snap_application.utility_heat?),
      yes_no_checkbox("utility_cooling", snap_application.utility_cooling?),
    ]
  end

  def benefit_application
    snap_application
  end

  def primary_member
    @_primary_member ||= snap_application.primary_member
  end

  def monthly_rent_taxes_and_insurance
    [
      snap_application.rent_expense,
      snap_application.property_tax_expense,
      snap_application.insurance_expense,
    ].compact.reduce(:+)
  end

  def first_member_with_disability_name
    disabled_members[0].try(:display_name)
  end

  def second_member_with_disability_name
    disabled_members[1].try(:display_name)
  end

  def third_member_with_disability_name
    disabled_members[2].try(:display_name)
  end

  def disabled_members
    @_disabled_members ||= snap_application.members.where(disabled: true)
  end

  def all_members_buy_food_with?
    !buy_food_with.include?(false)
  end

  def buy_food_with
    snap_application.members.map(&:buy_food_with?)
  end

  def members_not_buy_food_with
    snap_application.
      members.
      where.
      not(buy_food_with: true).
      pluck("concat(first_name, ' ', last_name) AS display_name").
      to_sentence
  end

  def more_than_six_members_yes
    snap_application.members_count > Dhs1171Pdf::MAXIMUM_HOUSEHOLD_MEMBERS
  end

  def more_than_two_self_employed_yes
    self_employed_household_members.length >
      Dhs1171Pdf::MAXIMUM_SELF_EMPLOYED_MEMBERS
  end

  def more_than_two_employed_yes
    employed_household_members.length > Dhs1171Pdf::MAXIMUM_EMPLOYED_MEMBERS
  end

  def financial_accounts(*types)
    included = types.select do |type|
      snap_application.financial_accounts.include?(type.to_s)
    end

    bool_to_checkbox(included.any?)
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
    if nil_if_zero(snap_application.property_tax_expense)
      snap_application.property_tax_expense * 12
    end
  end

  def annual_insurance_expense
    if nil_if_zero(snap_application.insurance_expense)
      snap_application.insurance_expense * 12
    end
  end

  def rent_expense_yes
    if !homeowner?
      bool_to_checkbox(rent_expense.present?)
    end
  end

  def mortgage_expense_yes
    if homeowner?
      bool_to_checkbox(mortgage_expense.present?)
    end
  end

  def rent_expense
    if !homeowner?
      nil_if_zero(snap_application.rent_expense)
    end
  end

  def mortgage_expense
    if homeowner?
      nil_if_zero(snap_application.rent_expense)
    end
  end

  def homeowner?
    nil_if_zero(snap_application.insurance_expense).present? ||
      nil_if_zero(snap_application.property_tax_expense).present?
  end

  def residential_or_homeless
    if benefit_application.stable_housing?
      full_street_address(benefit_application.residential_address)
    else
      "Homeless"
    end
  end

  def full_street_address(address)
    [address.street_address, address.street_address_2].
      reject(&:blank?).
      join(", ")
  end

  def nil_if_zero(value)
    value&.zero? ? nil : value
  end
end
