require "rails_helper"

RSpec.describe Dhs1171Pdf do
  describe "#save" do
    it "saves the client info" do
      mailing_address = create(:mailing_address)
      snap_application = create(:snap_application, addresses: [mailing_address])
      client_data = {
        applying_for_food_assistance: "Yes",
        full_name: snap_application.full_name,
        birth_day: snap_application.birthday.strftime("%d"),
        birth_month: snap_application.birthday.strftime("%m"),
        birth_year: snap_application.birthday.strftime("%Y"),
        street_address: mailing_address.street_address,
        city: mailing_address.city,
        county: mailing_address.county,
        state: mailing_address.state,
        zip: mailing_address.zip,
        signature: snap_application.signature,
        signature_date: snap_application.signed_at.to_s,
      }

      file = Dhs1171Pdf.new(snap_application: snap_application).completed_file

      result = filled_in_values(file: file.path)
      client_data.each do |field, entered_data|
        expect(result[field.to_s]).to eq entered_data
      end
    end

    it "prepends a cover sheet" do
      snap_application = create(:snap_application)
      original_length = PDF::Reader.new(Dhs1171Pdf::SOURCE_PDF).page_count

      file = Dhs1171Pdf.new(snap_application: snap_application).completed_file
      new_pdf = PDF::Reader.new(file.path)

      expect(new_pdf.page_count).to eq(original_length + 1)
    end

    it "returns the tempfile" do
      snap_application = create(:snap_application)

      file = Dhs1171Pdf.new(snap_application: snap_application).completed_file

      expect(file).to be_a_kind_of(Tempfile)
    end
  end

  def filled_in_values(file:)
    filled_in_fields = pdftk.get_fields(file)

    filled_in_fields.each_with_object({}) do |field, hash|
      hash[field.name] = field.value
    end
  end

  def pdftk
    @_pdftk ||= PdfForms.new
  end
end
