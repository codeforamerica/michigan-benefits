class MedicaidApplicationAttributes
  include PdfAttributes

  def initialize(medicaid_application:)
    @medicaid_application = medicaid_application
  end

  private

  attr_reader :medicaid_application

  def attributes
    [
      {
        signature: medicaid_application.signature,
        signature_date: mmddyyyy_date(medicaid_application.signed_at),
        residential_address_county:
          medicaid_application.residential_address.county,
        residential_address_state:
          medicaid_application.residential_address.state,
        residential_address_street_address: residential_or_homeless,
        residential_address_street_address_2:
          medicaid_application.residential_address.street_address_2,
        residential_address_zip: medicaid_application.residential_address.zip,
        residential_address_city: medicaid_application.residential_address.city,
        email: medicaid_application.email,
        mailing_address_city: medicaid_application.mailing_address.city,
        mailing_address_county: medicaid_application.mailing_address.county,
        mailing_address_state: medicaid_application.mailing_address.state,
        mailing_address_street_address:
          medicaid_application.mailing_address.street_address,
        mailing_address_street_address_2:
          medicaid_application.mailing_address.street_address_2,
        mailing_address_zip: medicaid_application.mailing_address.zip,
        receive_info_by_email:
          bool_to_checkbox(medicaid_application.email.present?),
        not_receive_info_by_email:
          bool_to_checkbox(medicaid_application.email.blank?),
      },
      phone_attributes,
      insurance_attributes,
      yes_no_checkbox("flint_water", medicaid_application.flint_water_crisis),
      yes_no_checkbox(
        "need_medical_expense_help_3_months",
        medicaid_application.need_medical_expense_help_3_months,
      ),
      yes_no_checkbox("anyone_insured", medicaid_application.anyone_insured),
      yes_no_checkbox(
        "filing_federal_taxes_next_year",
        medicaid_application.filing_federal_taxes_next_year,
      ),
      yes_no_checkbox("any_member_tax_relationship_dependent", dependents.any?),
      dependent_member_names: first_names(dependents),
    ]
  end

  def insurance_attributes
    {}.tap do |hash|
      {
        medicaid: "Medicaid",
        medicare: "Medicare",
        chip: "CHIP/MIChild",
        va: "VA health care programs",
        employer: "Employer or individual plan",
        other: "Other",
      }.each do |insurance_slug, insurance_name|
        members = members_with_insurance_type(insurance_name)
        anyone_has_insurance_type = members.any? ? "Yes" : nil
        names_with_insurance_type = first_names(members)

        if insurance_slug == :medicare
          hash[:help_paying_medicare_premiums_yes] = anyone_has_insurance_type
        end

        hash[:"insured_#{insurance_slug}_yes"] = anyone_has_insurance_type
        hash[:"insured_#{insurance_slug}_member_names"] =
          names_with_insurance_type
      end
    end
  end

  def members_with_insurance_type(insurance_name)
    medicaid_application.members.select do |member|
      member.insurance_type == insurance_name
    end
  end

  def benefit_application
    medicaid_application
  end

  def residential_or_homeless
    if benefit_application.stable_housing?
      benefit_application.residential_address.street_address
    else
      "Homeless"
    end
  end
end
