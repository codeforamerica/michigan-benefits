class Dhs1426Pdf
  PDF_DIRECTORY = "app/lib/pdfs".freeze
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
        member_tax_data = MedicaidApplicationAdditionalMemberTaxAttributes.
          new(member: record[:member]).to_h
        data = member_data.merge(member_tax_data)
        output_path = additional_member_pdf_output(index).path

        PdfForms.new.fill_form(STEP_2_ADDITIONAL_MEMBER_PDF, output_path, data)

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
    first_member_attributes.merge(second_member_attributes)
  end

  def first_member_attributes
    MedicaidApplicationMemberAttributes.
      new(member: application_members[0], position: "primary").to_h.merge(
        primary_member_tax_attributes,
      )
  end

  def primary_member_tax_attributes
    MedicaidApplicationPrimaryMemberTaxAttributes.
      new(member: primary_member).to_h
  end

  def second_member_attributes
    if second_member.present?
      MedicaidApplicationMemberAttributes.
        new(member: second_member, position: "second").to_h.merge(
          second_member_tax_attributes,
        )
    else
      {}
    end
  end

  def second_member_tax_attributes
    MedicaidApplicationAdditionalMemberTaxAttributes.
      new(member: second_member).to_h
  end

  def application_members
    @_application_members ||= medicaid_application.members.order(:id)
  end

  def first_two_members
    [
      { member: primary_member, position: "primary" },
      { member: second_member, position: "second" },
    ]
  end

  def primary_member
    application_members[0]
  end

  def second_member
    application_members[1]
  end

  def verification_paperwork_paths
    verification_paperwork.map do |document|
      VerificationDocument.new(
        url: document,
        benefit_application: medicaid_application,
      ).file.path
    end.reject(&:nil?)
  end

  def verification_paperwork
    medicaid_application.paperwork || []
  end
end
