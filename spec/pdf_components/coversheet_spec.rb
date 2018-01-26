require "spec_helper"
require_relative "../../app/pdf_components/coversheet"
require_relative "../support/shared_examples/pdf_component"

describe Coversheet do
  let(:subject) do
    Coversheet.new
  end

  describe "pdf component" do
    it_should_behave_like "pdf component"
  end

  describe "#fill?" do
    it "returns false" do
      expect(subject.fill?).to be_falsey
    end
  end

  describe "#output_file" do
    it "returns a pdf file object" do
      expect(subject.output_file).to be_instance_of(File)
    end
  end
end
