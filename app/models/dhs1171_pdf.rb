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
    snap_application_attributes.
      merge(member_attributes).
      merge(employed_member_attributes).
      merge(self_employed_member_attributes).
      merge(additional_income_attributes)
  end

  def snap_application_attributes
    SnapApplicationAttributes.new(snap_application: snap_application).to_h
  end

  def member_attributes
    map_attributes(
      records: first_six_members,
      klass: SnapApplicationMemberAttributes,
    )
  end

  def employed_member_attributes
    map_attributes(
      records: first_two_employed_members,
      klass: EmployedMemberAttributes,
    )
  end

  def self_employed_member_attributes
    map_attributes(
      records: first_two_self_employed_members,
      klass: SelfEmployedMemberAttributes,
    )
  end

  def additional_income_attributes
    if additional_income_source.length <= 3
      first_three_additional_income_sources.map do |attrs|
        if attrs[:source].present?
          AdditionalIncomeSource.new(attrs).to_h
        end
      end.compact.reduce({}, :merge)
    else
      { more_than_three_additional_income_sources: "See appended page" }
    end
  end

  def map_attributes(records:, klass:)
    records.map do |record|
      if record[:member].present?
        klass.new(record).to_h
      end
    end.compact.reduce({}, :merge)
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

  def first_six_members
    [
      { member: application_members[0], position: "primary" },
      { member: application_members[1], position: "second" },
      { member: application_members[2], position: "third" },
      { member: application_members[3], position: "fourth" },
      { member: application_members[4], position: "fifth" },
      { member: application_members[5], position: "sixth" },
    ]
  end

  def first_two_employed_members
    [
      { member: employed_members[0], position: "first" },
      { member: employed_members[1], position: "second" },
    ]
  end

  def first_two_self_employed_members
    [
      { member: self_employed_members[0], position: "first" },
      { member: self_employed_members[1], position: "second" },
    ]
  end

  def first_three_additional_income_sources
    [
      {
        source: additional_income_source[0],
        position: "first",
        snap_application: snap_application,
      },
      {
        source: additional_income_source[1],
        position: "second",
        snap_application: snap_application,
      },
      {
        source: additional_income_source[2],
        position: "third",
        snap_application: snap_application,
      },
    ]
  end

  def employed_members
    @_employed_members ||=
      application_members.where(employment_status: "employed")
  end

  def self_employed_members
    @_self_employed_members ||=
      application_members.where(employment_status: "self_employed")
  end

  def additional_income_source
    @_additional_income_source ||= snap_application.additional_income
  end

  def application_members
    @_application_members ||= snap_application.members.order(:id)
  end
end
