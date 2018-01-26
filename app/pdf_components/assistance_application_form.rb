class AssistanceApplicationForm
  include PdfAttributes

  def fill?
    true
  end

  def initialize(benefit_application)
    @benefit_application = benefit_application
  end

  def source_pdf_path
    "app/lib/pdfs/AssistanceApplication.pdf"
  end

  def attributes
    applicant_registration_attributes
  end

  def applicant_registration_attributes
    {
      applying_for_food: "Yes",
      legal_name: benefit_application.display_name,
      is_homeless: bool_to_checkbox(benefit_application.unstable_housing?),
      residential_address_street: benefit_application.residential_address.street_address,
      residential_address_apt: benefit_application.residential_address.street_address_2,
      residential_address_city: benefit_application.residential_address.city,
      residential_address_county: benefit_application.residential_address.county,
      residential_address_state: benefit_application.residential_address.state,
      residential_address_zip: benefit_application.residential_address.zip,
      mailing_address: mailing_address_if_different,
      dob: benefit_application.primary_member.birthday.strftime("%m/%d/%Y"),
      phone_home: formatted_phone,
      email: benefit_application.email,
      signature_applicant: benefit_application.signature,
      signature_date: benefit_application.signed_at_est("%m/%d/%Y"),
    }
  end

  def output_file
    @_output_file ||= Tempfile.new(["assistance_app", ".pdf"], "tmp/")
  end

  private

  attr_reader :benefit_application

  def mailing_address_if_different
    return if benefit_application.mailing_address == benefit_application.residential_address
    return if benefit_application.mailing_address.is_a?(NullAddress)

    full_address(benefit_application.mailing_address)
  end

  def full_address(address)
    [
      address.street_address,
      address.street_address_2,
      address.city,
      address.county,
      address.state,
      address.zip,
    ].compact.join(", ")
  end
end
