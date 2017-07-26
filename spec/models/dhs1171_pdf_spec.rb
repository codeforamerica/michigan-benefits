require "rails_helper"

RSpec.describe Dhs1171Pdf do
  describe "#save" do
    it "saves the client info" do
      client_data = {
        applying_for_food_assistance: "Yes",
        birth_day: "11",
        birth_month: "7",
        birth_year: "1950",
        city: "Flint",
        county: "Genesee",
        full_name: "Jessie Tester",
        signature: "Jessie Tester",
        signature_date: "July 25, 2017",
        state: "MI",
        street_address: "123 Main St",
        zip: "12345",
      }

      Dhs1171Pdf.new(client_data).save(generated_pdf)

      result = filled_in_values(file: generated_pdf)
      client_data.each do |field, entered_data|
        expect(result[field.to_s]).to eq entered_data
      end

      File.delete(generated_pdf) if File.exist?(generated_pdf)
    end

    it "errors if keys are passed in for non-existent fields" do
      client_data = { blah: "hello" }

      expect do
        Dhs1171Pdf.new(client_data).save(generated_pdf)
      end.to raise_error("Invalid fields passed in: [\"blah\"]")
    end
  end

  def filled_in_values(file:)
    filled_in_fields = pdftk.get_fields(file)

    filled_in_fields.each_with_object({}) do |field, hash|
      hash[field.name] = field.value
    end
  end

  def generated_pdf
    @_generated_pdf ||= "tmp/dhs1171_test_output.pdf"
  end

  def pdftk
    @_pdftk ||= PdfForms.new
  end
end
