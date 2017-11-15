class MedicaidApplicationAttributes
  include PdfAttributes

  def initialize(medicaid_application:)
    @medicaid_application = medicaid_application
  end

  def to_h
    {
      signature: medicaid_application.signature,
      residential_address_county:
        medicaid_application.residential_address.county,
      residential_address_state: medicaid_application.residential_address.state,
      residential_address_street_address: residential_or_homeless,
      residential_address_zip: medicaid_application.residential_address.zip,
      residential_address_city: medicaid_application.residential_address.city,
      email: medicaid_application.email,
      mailing_address_city: medicaid_application.mailing_address.city,
      mailing_address_county: medicaid_application.mailing_address.county,
      mailing_address_state: medicaid_application.mailing_address.state,
      mailing_address_street_address:
        medicaid_application.mailing_address.street_address,
      mailing_address_zip: medicaid_application.mailing_address.zip,
      receive_info_by_email:
        bool_to_checkbox(medicaid_application.email.present?),
      not_receive_info_by_email:
        bool_to_checkbox(medicaid_application.email.blank?),
      preferred_language: nil,
      flint_water_key => "Yes",
      need_medical_expense_help_key => "Yes",
    }.merge(phone_attributes).symbolize_keys
  end

  private

  attr_reader :medicaid_application

  def flint_water_key
    "flint_water_#{yes_no(medicaid_application.flint_water_crisis)}"
  end

  def need_medical_expense_help_key
    yes_no = yes_no(medicaid_application.need_medical_expense_help_3_months)
    "need_medical_expense_help_3_months_#{yes_no}"
  end

  def benefit_application
    medicaid_application
  end
end
