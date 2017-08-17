class Dhs1171Pdf
  PDF_DIRECTORY = "lib/pdfs".freeze
  SOURCE_PDF = "#{PDF_DIRECTORY}/DHS_1171.pdf".freeze
  COVERSHEET_PDF = "#{PDF_DIRECTORY}/michigan_snap_fax_cover_letter.pdf".freeze

  def initialize(snap_application:)
    @snap_application = snap_application
  end

  def completed_file
    complete_template_pdf_with_client_data
    prepend_cover_sheet_to_completed_form
    complete_form_with_cover
  ensure
    filled_in_form.close
    filled_in_form.unlink
  end

  private

  attr_reader :snap_application

  def complete_template_pdf_with_client_data
    PdfForms.new.fill_form(SOURCE_PDF, filled_in_form.path, client_data)
  end

  def filled_in_form
    @_filled_in_form ||= Tempfile.new(["snap_app", ".pdf"], "tmp/")
  end

  def client_data
    {
      applying_for_food_assistance: "Yes",
      primary_member_full_name: primary_member.full_name,
      birth_day: primary_member.birthday.strftime("%d"),
      birth_month: primary_member.birthday.strftime("%m"),
      birth_year: primary_member.birthday.strftime("%Y"),
      phone_number: snap_application.phone_number,
      primary_member_sex_male:
        boolean_to_checkbox(primary_member.sex == "male"),
      primary_member_sex_female:
        boolean_to_checkbox(primary_member.sex == "female"),
      mailing_address_street_address:
        snap_application.mailing_address.street_address,
      mailing_address_city: snap_application.mailing_address.city,
      mailing_address_county: snap_application.mailing_address.county,
      mailing_address_state: snap_application.mailing_address.state,
      mailing_address_zip: snap_application.mailing_address.zip,
      residential_address_street_address:
        snap_application.residential_address.street_address,
      residential_address_city: snap_application.residential_address.city,
      residential_address_county: snap_application.residential_address.county,
      residential_address_state: snap_application.residential_address.state,
      residential_address_zip: snap_application.mailing_address.zip,
      email: snap_application.email,
      signature: snap_application.signature,
      signature_date: snap_application.signed_at,
      primary_member_birthday: primary_member.birthday.strftime("%m/%d/%Y"),
      primary_member_ssn: primary_member.ssn,
      primary_member_marital_status_married:
        boolean_to_checkbox(primary_member.marital_status == "Married"),
      primary_member_marital_status_never_married:
        boolean_to_checkbox(primary_member.marital_status == "Never married"),
      primary_member_marital_status_divorced:
        boolean_to_checkbox(primary_member.marital_status == "Divorced"),
      primary_member_marital_status_widowed:
        boolean_to_checkbox(primary_member.marital_status == "Widowed"),
      primary_member_marital_status_separated:
        boolean_to_checkbox(primary_member.marital_status == "Separated"),
      primary_member_citizen_yes: boolean_to_checkbox(primary_member.citizen?),
      primary_member_citizen_no: boolean_to_checkbox(!primary_member.citizen?),
      primary_member_new_mom_yes: boolean_to_checkbox(primary_member.new_mom?),
      primary_member_new_mom_no: boolean_to_checkbox(!primary_member.new_mom?),
      primary_member_in_college_yes:
        boolean_to_checkbox(primary_member.in_college?),
      primary_member_in_college_no:
        boolean_to_checkbox(!primary_member.in_college?),

    }
  end

  def prepend_cover_sheet_to_completed_form
    system(
      <<~eos
        pdftk #{COVERSHEET_PDF} #{filled_in_form.path} cat output #{complete_form_with_cover.path}
      eos
    )
  end

  def complete_form_with_cover
    @_complete_form_with_cover ||=
      Tempfile.new(["snap_app_with_cover", ".pdf"], "tmp/")
  end

  def primary_member
    @_primary_member ||= snap_application.primary_member
  end

  def boolean_to_checkbox(statement)
    if statement == true
      "Yes"
    end
  end
end
