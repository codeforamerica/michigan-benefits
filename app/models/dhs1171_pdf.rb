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
      birth_day: primary_member.birthday.strftime("%d"),
      birth_month: primary_member.birthday.strftime("%m"),
      birth_year: primary_member.birthday.strftime("%Y"),
      phone_number: snap_application.phone_number,
      mailing_address_street_address:
        snap_application.mailing_address.street_address,
      mailing_address_city: snap_application.mailing_address.city,
      mailing_address_county: snap_application.mailing_address.county,
      mailing_address_state: snap_application.mailing_address.state,
      mailing_address_zip: snap_application.mailing_address.zip,
      residential_address_street_address: residential_or_homeless,
      residential_address_city: snap_application.residential_address.city,
      residential_address_county: snap_application.residential_address.county,
      residential_address_state: snap_application.residential_address.state,
      residential_address_zip: snap_application.mailing_address.zip,
      email: snap_application.email,
      signature: snap_application.signature,
      signature_date: snap_application.signed_at,
      members_buy_food_with_yes:
        boolean_to_checkbox(all_members_buy_food_with?),
      members_buy_food_with_no:
        boolean_to_checkbox(any_members_not_buy_food_with?),
      members_not_buy_food_with: members_not_buy_food_with,
    }.merge(member_attributes)
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

  def member_attributes
    first_six_members.map do |attrs|
      if attrs[:member].present?
        Dhs1171PdfMemberAttributes.new(attrs).to_h
      end
    end.compact.reduce({}, :merge)
  end

  def first_six_members
    [
      { member: primary_member, position: "primary" },
      { member: application_members[1], position: "second" },
      { member: application_members[2], position: "third" },
      { member: application_members[3], position: "fourth" },
      { member: application_members[4], position: "fifth" },
      { member: application_members[5], position: "sixth" },
    ]
  end

  def application_members
    @_application_members ||= snap_application.members.order(:id)
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
      map(&:full_name).
      to_sentence
  end
end
