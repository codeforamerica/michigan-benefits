class MedicaidApplicationAttributes
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
    }.merge(phone_attributes).symbolize_keys
  end

  private

  attr_reader :medicaid_application

  def bool_to_checkbox(statement)
    if statement == true
      "Yes"
    end
  end

  def residential_or_homeless
    if medicaid_application.stable_housing?
      medicaid_application.residential_address.street_address
    else
      "Homeless"
    end
  end

  def phone_attributes
    if medicaid_application.phone_number.nil?
      {}
    else
      ten_digit_phone.each_with_index.reduce({}) do |memo, (phone_digit, index)|
        memo["phone_number_#{index}"] = phone_digit
        memo
      end
    end
  end

  def ten_digit_phone
    medicaid_application.phone_number.split("")
  end
end
