require "rails_helper"

RSpec.describe MbFormBuilder do
  describe "#field_values" do
    it "returns value that is present wrapped in an array" do
      class SampleStep < Step
        step_attributes(:phone_number)
      end

      sample = SampleStep.new
      sample.phone_number = "5551009000"
      form = MbFormBuilder.new("sample", sample, nil, {})

      expect(form.field_values({}, :phone_number)).to eq ["5551009000"]
    end

    it "returns existing array of values" do
      class SampleStep < Step
        step_attributes(numbers: [])
      end

      sample = SampleStep.new
      sample.numbers = [1, 2]
      form = MbFormBuilder.new("sample", sample, nil, {})

      expect(form.field_values({}, :numbers)).to eq [1, 2]
    end

    it "returns a single empty string if attribute is not set" do
      class SampleStep < Step
        step_attributes(numbers: [])
      end

      sample = SampleStep.new
      form = MbFormBuilder.new("sample", sample, nil, {})

      expect(form.field_values({}, :numbers)).to eq [""]
    end

    it "returns however many blank strings according to options[:count]" do
      class SampleStep < Step
        step_attributes(numbers: [])
      end

      sample = SampleStep.new
      form = MbFormBuilder.new("sample", sample, nil, {})

      expect(form.field_values({ count: 3 }, :numbers)).to eq ["", "", ""]
    end
  end
end
