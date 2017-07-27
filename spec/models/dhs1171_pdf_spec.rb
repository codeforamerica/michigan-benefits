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

      Dhs1171Pdf.new(snap_application).save(generated_pdf)

      result = filled_in_values(file: generated_pdf)
      client_data.each do |field, entered_data|
        expect(result[field.to_s]).to eq entered_data
      end

      File.delete(generated_pdf) if File.exist?(generated_pdf)
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
