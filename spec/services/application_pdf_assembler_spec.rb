require "rails_helper"

RSpec.describe ApplicationPdfAssembler do
  it "calls PdfBuilder with coversheet and PDF configurations" do
    fake_application = double("application")
    fake_application_form = double("application form")
    fake_concatenator = double("concatenator", run: "concatenator output")

    allow(AssistanceApplicationForm).to receive(:new).with(fake_application) { fake_application_form }
    allow(PdfConcatenator).to receive(:new).with([fake_application_form]) { fake_concatenator }

    pdf_composer = ApplicationPdfAssembler.new(snap_application: fake_application)
    expect(pdf_composer.run).to eq("concatenator output")
  end
end
