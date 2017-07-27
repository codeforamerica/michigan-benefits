require "rails_helper"

RSpec.describe Dhs1171Pdf do
  describe "#save" do
    it "saves the client info" do
      snap_application = FactoryGirl.create(:snap_application)
      client_data = {
        applying_for_food_assistance: "Yes",
        full_name: snap_application.name,
        birth_day: snap_application.birthday.strftime("%d"),
        birth_month: snap_application.birthday.strftime("%m"),
        birth_year: snap_application.birthday.strftime("%Y"),
        street_address: snap_application.street_address,
        city: snap_application.city,
        county: snap_application.county,
        state: snap_application.state,
        zip: snap_application.zip,
        signature: snap_application.signature,
        signature_date: snap_application.signed_at.to_s,
      }

      Dhs1171Pdf.new(
        snap_application: snap_application,
        output_filename: new_pdf_filename,
      ).save

      result = filled_in_values(file: "tmp/#{new_pdf_filename}")
      client_data.each do |field, entered_data|
        expect(result[field.to_s]).to eq entered_data
      end

      File.delete(new_pdf_filename) if File.exist?(new_pdf_filename)
    end

    it "prepends a cover sheet" do
      snap_application = FactoryGirl.create(:snap_application)
      original_length = PDF::Reader.new(Dhs1171Pdf::SOURCE_PDF).page_count

      Dhs1171Pdf.new(
        snap_application: snap_application,
        output_filename: new_pdf_filename,
      ).save
      new_pdf = PDF::Reader.new("tmp/#{new_pdf_filename}")

      expect(new_pdf.page_count).to eq(original_length + 1)
    end
  end

  def filled_in_values(file:)
    filled_in_fields = pdftk.get_fields(file)

    filled_in_fields.each_with_object({}) do |field, hash|
      hash[field.name] = field.value
    end
  end

  def new_pdf_filename
    @_new_pdf_filename ||= "dhs1171_test_output.pdf"
  end

  def pdftk
    @_pdftk ||= PdfForms.new
  end
end
