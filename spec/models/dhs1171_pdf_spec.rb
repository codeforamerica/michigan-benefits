require "rails_helper"

RSpec.describe Dhs1171Pdf do
  describe "#save" do
    after do
      # File.delete(new_pdf_filename) if File.exist?(new_pdf_filename)
    end

    it "saves the client info" do
      client_data = {
        applying_for_food_assistance: "Yes",
        birth_day: "11",
        birth_month: "7",
        birth_year: "1950",
        city: "Flint",
        county: "Genesee",
        full_name: "Alan Tester",
        signature: "Alan Tester",
        signature_date: "July 25, 2017",
        state: "MI",
        street_address: "123 Hello St",
        zip: "12345",
      }

      Dhs1171Pdf.new(client_data: client_data, filename: new_pdf_filename).save

      result = filled_in_values(file: new_pdf_filename)
      client_data.each do |field, entered_data|
        expect(result[field.to_s]).to eq entered_data
      end

      File.delete(new_pdf_filename) if File.exist?(new_pdf_filename)
    end

    it "errors if keys are passed in for non-existent fields" do
      client_data = { blah: "hello" }

      expect do
        Dhs1171Pdf.new(client_data: client_data, filename: new_pdf_filename).save
      end.to raise_error("Invalid fields passed in: [\"blah\"]")
    end

    it "prepends a cover sheet" do
      original_length = PDF::Reader.new(Dhs1171Pdf::SOURCE_PDF).page_count
      client_data = { city: "hello" }

      Dhs1171Pdf.new(client_data: client_data, filename: new_pdf_filename).save
      new_pdf = PDF::Reader.new(new_pdf_filename)

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
    @_new_pdf_filename ||= "tmp/dhs1171_test_output.pdf"
  end

  def pdftk
    @_pdftk ||= PdfForms.new
  end
end
