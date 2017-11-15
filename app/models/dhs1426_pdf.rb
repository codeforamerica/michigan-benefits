class Dhs1426Pdf
  PDF_DIRECTORY = "lib/pdfs".freeze
  SOURCE_PDF = "#{PDF_DIRECTORY}/DHS_1426.pdf".freeze

  def initialize(medicaid_application:)
    @medicaid_application = medicaid_application
  end

  def completed_file
    complete_template_pdf_with_client_data
    assemble_complete_application
  ensure
    filled_in_application.close
    filled_in_application.unlink
  end

  private

  attr_reader :medicaid_application

  def complete_template_pdf_with_client_data
    PdfForms.new.fill_form(SOURCE_PDF, filled_in_application.path, client_data)
  end

  def assemble_complete_application
    PdfBuilder.new(
      output_file: complete_application,
      file_paths: [
        filled_in_application.path,
      ].reject(&:blank?).flatten,
    ).pdf
  end

  def filled_in_application
    @_filled_in_application ||= Tempfile.new(["medicaid_app", ".pdf"], "tmp/")
  end

  def complete_application
    @_complete_application ||= Tempfile.new(
      ["medicaid_app_complete", ".pdf"],
      "tmp/",
    )
  end

  def client_data
    medicaid_application_attributes.
      merge(member_attributes)
  end

  def medicaid_application_attributes
    MedicaidApplicationAttributes.
      new(medicaid_application: medicaid_application).
      to_h
  end

  def member_attributes
    first_two_members.map do |record|
      if record[:member].present?
        MedicaidApplicationMemberAttributes.new(record).to_h
      end
    end.compact.reduce({}, :merge)
  end

  def application_members
    @_application_members ||= medicaid_application.members.order(:id)
  end

  def first_two_members
    [
      { member: application_members[0], position: "primary" },
      { member: application_members[1], position: "second" },
    ]
  end
end
