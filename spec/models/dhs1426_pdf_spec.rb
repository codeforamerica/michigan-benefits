require "rails_helper"
require_relative "../support/pdf_helper"

RSpec.describe Dhs1426Pdf do
  include PdfHelper

  describe "#completed_file" do
    it "writes application data to file" do
      member = create(
        :member,
        first_name: "Christa",
        last_name: "Tester",
      )
      medicaid_application = create(
        :snap_application,
        members: [member],
      )
      expected_client_data = {
        primary_member_full_name: member.display_name,
      }

      file = Dhs1426Pdf.new(
        medicaid_application: medicaid_application,
      ).completed_file

      result = filled_in_values(file: file.path)
      expected_client_data.each do |field, expected_data|
        expect(result[field.to_s].to_s).to eq expected_data.to_s
      end
    end

    it "returns the tempfile" do
      medicaid_application = create(:medicaid_application, :with_member)

      file = Dhs1426Pdf.new(
        medicaid_application: medicaid_application,
      ).completed_file

      expect(file).to be_a_kind_of(Tempfile)
    end
  end
end
