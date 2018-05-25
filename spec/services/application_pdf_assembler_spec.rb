require "spec_helper"
require "rspec/rails"
require_relative "../../app/services/application_pdf_assembler"
require_relative "../../app/services/pdf_concatenator"
require_relative "../../app/pdf_components/coversheet"
require_relative "../../app/models/concerns/pdf_attributes"
require_relative "../../app/pdf_components/assistance_application_form"
require_relative "../../app/pdf_components/food_assistance_supplement"
require_relative "../../app/models/verification_document"

RSpec.describe ApplicationPdfAssembler do
  context "basic application" do
    context "with verification paperwork" do
      it "returns a PDF that includes the assistance application form and verification paperwork" do
        fake_application = instance_double(CommonApplication,
          applying_for_food_assistance?: false,
          applying_for_healthcare?: false,
          paperwork: ["example.com/images/test1.jpg", "example.com/images/test2.png"])

        fake_coversheet = instance_double(Coversheet)
        expect(Coversheet).to receive(:new).and_return(fake_coversheet)

        fake_application_form = instance_double("application form")
        expect(AssistanceApplicationForm).to receive(:new).with(fake_application).and_return(fake_application_form)

        fake_verification_doc1 = instance_double(VerificationDocument)
        fake_verification_doc2 = instance_double(VerificationDocument)

        expect(VerificationDocument).to receive(:new).
          with(url: "example.com/images/test1.jpg", benefit_application: fake_application).
          and_return(fake_verification_doc1)
        expect(VerificationDocument).to receive(:new).
          with(url: "example.com/images/test2.png", benefit_application: fake_application).
          and_return(fake_verification_doc2)

        fake_complete_pdf = double("complete pdf")
        fake_pdf_concatenator = instance_double(PdfConcatenator)

        expected_components = [
          fake_coversheet,
          fake_application_form,
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

  context "basic application with food assistance supplement" do
    it "returns a PDF with both the basic application and food assistance supplement" do
      fake_application = instance_double(CommonApplication,
        applying_for_food_assistance?: true,
        applying_for_healthcare?: false,
        paperwork: [])

      fake_coversheet = instance_double(Coversheet)
      expect(Coversheet).to receive(:new).and_return(fake_coversheet)

      fake_application_form = instance_double(AssistanceApplicationForm)
      expect(AssistanceApplicationForm).to receive(:new).with(fake_application).and_return(fake_application_form)

      fake_snap_supplement = instance_double(FoodAssistanceSupplement)
      expect(FoodAssistanceSupplement).to receive(:new).with(fake_application).and_return(fake_snap_supplement)

      fake_complete_pdf = double("complete pdf")
      fake_pdf_concatenator = instance_double(PdfConcatenator)

      expected_components = [fake_coversheet, fake_application_form, fake_snap_supplement]

      expect(PdfConcatenator).to receive(:new).with(expected_components).and_return(fake_pdf_concatenator)

      expect(fake_pdf_concatenator).to receive(:run).and_return(fake_complete_pdf)
      result = ApplicationPdfAssembler.new(benefit_application: fake_application).run
      expect(result).to be(fake_complete_pdf)
    end
  end

  context "basic application with healthcare supplement" do
    it "returns a PDF with both the basic application and healthcare supplement" do
      fake_application = instance_double(CommonApplication,
        applying_for_food_assistance?: false,
        applying_for_healthcare?: true,
        paperwork: [])

      fake_coversheet = instance_double(Coversheet)
      expect(Coversheet).to receive(:new).and_return(fake_coversheet)

      fake_application_form = instance_double(AssistanceApplicationForm)
      expect(AssistanceApplicationForm).to receive(:new).with(fake_application).and_return(fake_application_form)

      fake_healthcare_supplement = instance_double(HealthcareCoverageSupplement)
      expect(HealthcareCoverageSupplement).to receive(:new).with(fake_application).
        and_return(fake_healthcare_supplement)

      fake_complete_pdf = double("complete pdf")
      fake_pdf_concatenator = instance_double(PdfConcatenator)

      expected_components = [fake_coversheet, fake_application_form, fake_healthcare_supplement]

      expect(PdfConcatenator).to receive(:new).with(expected_components).and_return(fake_pdf_concatenator)

      expect(fake_pdf_concatenator).to receive(:run).and_return(fake_complete_pdf)
      result = ApplicationPdfAssembler.new(benefit_application: fake_application).run
      expect(result).to be(fake_complete_pdf)
    end
  end
end
