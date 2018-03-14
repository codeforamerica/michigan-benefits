require "spec_helper"
require_relative "../../app/services/application_pdf_assembler"
require_relative "../../app/services/pdf_concatenator"
require_relative "../../app/pdf_components/coversheet"
require_relative "../../app/models/concerns/pdf_attributes"
require_relative "../../app/pdf_components/assistance_application_form"
require_relative "../../app/pdf_components/food_assistance_supplement"
require_relative "../../app/models/verification_document"

RSpec.describe ApplicationPdfAssembler do
  context "food assistance application with no verification documents" do
    it "returns a PDF that includes the assistance application form and no verification documents" do
      fake_application = double("application", applying_for_food_assistance?: true, documents: [])

      fake_coversheet = double("coversheet")
      expect(Coversheet).to receive(:new).and_return(fake_coversheet)

      fake_application_form = double("application form")
      expect(AssistanceApplicationForm).to receive(:new).with(fake_application).and_return(fake_application_form)

      fake_snap_supplement = double("food assistance supplement")
      expect(FoodAssistanceSupplement).to receive(:new).with(fake_application).and_return(fake_snap_supplement)

      fake_complete_pdf = double("complete pdf")
      fake_pdf_concatenator = double("pdf concatenator")

      expected_components = [fake_coversheet, fake_application_form, fake_snap_supplement]

      expect(PdfConcatenator).to receive(:new).with(expected_components).and_return(fake_pdf_concatenator)

      expect(fake_pdf_concatenator).to receive(:run).and_return(fake_complete_pdf)
      result = ApplicationPdfAssembler.new(benefit_application: fake_application).run
      expect(result).to be(fake_complete_pdf)
    end
  end

  context "application with verification documents" do
    it "returns a PDF that includes the assistance application form and verification documents" do
      fake_application = double("snap application",
                                applying_for_food_assistance?: true,
                                documents: ["example.com/images/test1.jpg", "example.com/images/test2.png"])

      fake_coversheet = double("coversheet")
      expect(Coversheet).to receive(:new).and_return(fake_coversheet)

      fake_application_form = double("application form")
      expect(AssistanceApplicationForm).to receive(:new).with(fake_application).and_return(fake_application_form)

      fake_snap_supplement = double("food assistance supplement")
      expect(FoodAssistanceSupplement).to receive(:new).with(fake_application).and_return(fake_snap_supplement)

      fake_verification_doc1 = double("fake doc 1")
      fake_verification_doc2 = double("fake doc 2")

      expect(VerificationDocument).to receive(:new).
        with(url: "example.com/images/test1.jpg", benefit_application: fake_application).
        and_return(fake_verification_doc1)
      expect(VerificationDocument).to receive(:new).
        with(url: "example.com/images/test2.png", benefit_application: fake_application).
        and_return(fake_verification_doc2)

      fake_complete_pdf = double("complete pdf")
      fake_pdf_concatenator = double("pdf concatenator")

      expected_components = [
        fake_coversheet,
        fake_application_form,
        fake_snap_supplement,
        fake_verification_doc1,
        fake_verification_doc2,
      ]

      expect(PdfConcatenator).to receive(:new).with(expected_components).and_return(fake_pdf_concatenator)

      expect(fake_pdf_concatenator).to receive(:run).and_return(fake_complete_pdf)
      result = ApplicationPdfAssembler.new(benefit_application: fake_application).run
      expect(result).to be(fake_complete_pdf)
    end
  end
end
