# frozen_string_literal: true

require "prawn"

class SnapApplicationExtraMemberPdf
  def initialize(members:)
    @members = members
  end

  def completed_file
    pdf = Prawn::Document.new
    pdf.font("Helvetica", size: 16) do
      pdf.text("Section C Continued")
    end
    pdf.move_down 10

    members.each do |member|
      attributes = SnapApplicationExtraMemberAttributes.new(member: member)

      pdf.font("Helvetica", size: 14) do
        pdf.text(attributes.title)
      end

      attributes.to_a.each do |attribute|
        pdf.text(attribute)
      end

      pdf.move_down 10
    end

    pdf.render_file(file_path)
    file_path
  end

  private

  attr_reader :members

  def file_path
    "tmp/#{filename}.pdf"
  end

  def filename
    @filename ||=
      "#{SecureRandom.hex}#{Time.now.strftime('%Y%m%d%H%M%S%L')}"
  end
end
