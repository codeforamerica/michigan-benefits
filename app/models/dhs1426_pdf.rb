class Dhs1426Pdf
  PDF_DIRECTORY = "lib/pdfs".freeze
  SOURCE_PDF = "#{PDF_DIRECTORY}/DHS_1426.pdf".freeze
  COVERSHEET_PDF = "#{PDF_DIRECTORY}/DHS_1426_cover_letter.pdf".freeze
  STEP_2_ADDITIONAL_MEMBER_PDF =
    "#{PDF_DIRECTORY}/DHS_1426_step_2_additional_member.pdf".freeze
  MAXIMUM_HOUSEHOLD_MEMBERS = 2

  def initialize(medicaid_application:)
    @medicaid_application = medicaid_application
  end

  def completed_file
    fill_template_pdf_with_client_data
    fill_step_2_pdf_for_additional_members
    assemble_complete_application
  ensure
    filled_in_application.close
    filled_in_application.unlink
  end

  private

  attr_reader :medicaid_application

  def fill_template_pdf_with_client_data
    PdfForms.new.fill_form(SOURCE_PDF, filled_in_application.path, client_data)
  end

  def fill_step_2_pdf_for_additional_members
    if application_members.length > MAXIMUM_HOUSEHOLD_MEMBERS
      additional_members.each_with_index do |record, index|
        member_data = MedicaidApplicationMemberAttributes.new(record).to_h

        output_path = additional_member_pdf_output(index).path

        PdfForms.new.fill_form(
          STEP_2_ADDITIONAL_MEMBER_PDF,
          output_path,
          member_data,
        )

        additional_member_pdf_paths << output_path
      end
    end
  end

  def additional_members
    @_additional_members ||= application_members[2..-1].map do |member|
      { member: member, position: "second" }
    end
  end

  def assemble_complete_application
    PdfBuilder.new(
      output_file: complete_application,
      file_paths: [
        COVERSHEET_PDF,
        filled_in_application.path,
        additional_member_pdf_paths,
        verification_paperwork_paths,
      ].reject(&:blank?).flatten,
    ).pdf
  end

  def filled_in_application
    @_filled_in_application ||= Tempfile.new(["medicaid_app", ".pdf"], "tmp/")
  end

  def additional_member_pdf_output(index)
    Tempfile.new(["medicaid_additional_member_#{index}", ".pdf"], "tmp/")
  end

  def additional_member_pdf_paths
    @_additional_member_pdf_paths ||= []
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

  def verification_paperwork_paths
    verification_paperwork.map do |document|
      VerificationDocument.new(
        url: document,
        benefit_application: medicaid_application,
      ).file&.path
    end.reject(&:nil?)
  end

  def verification_paperwork
    medicaid_application.paperwork || []
  end
end
