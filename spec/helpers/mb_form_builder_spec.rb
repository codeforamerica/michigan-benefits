require "rails_helper"

RSpec.describe MbFormBuilder do
  let(:template) do
    template = OpenStruct.new(output_buffer: "")
    template.extend ActionView::Helpers::FormHelper
    template.extend ActionView::Helpers::FormTagHelper
    template.extend ActionView::Helpers::FormOptionsHelper
  end

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

  describe "#mb_input_field" do
    it "renders a label that contains a p tag" do
      class SampleStep < Step
        step_attributes(:name)
      end
      sample = SampleStep.new
      form = MbFormBuilder.new("sample", sample, template, {})
      output = form.mb_input_field(:name, "How is name?")
      expect(output).to be_html_safe
      expect(output).to match_html <<-HTML
        <div class="form-group">
          <label for="sample_name">
            <p class="form-question">How is name?</p>
          </label>
          <input type="text" class="text-input" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" value="" name="sample[name]" id="sample_name" />
        </div>
      HTML
    end
  end

  describe "#mb_phone_field" do
    it "renders a tel input with a '+1' prefix" do
      class SampleStep < Step
        step_attributes(:phone_number)
      end

      sample = SampleStep.new
      form = MbFormBuilder.new("sample", sample, template, {})
      output = form.mb_phone_number_field(:phone_number, "What is phone?")
      expect(output).to be_html_safe
      expect(output).to match_html <<-HTML
        <div class="form-group">
          <label for="sample_phone_number">
            <p class="form-question">What is phone?</p>
          </label>
          <div class="text-input-group">
            <div class="text-input-group__prefix">+1</div>
            <input type="tel" class="text-input" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" value="" name="sample[phone_number]" id="sample_phone_number" />
          </div>
        </div>
      HTML
    end
  end

  describe "#mb_select" do
    it "can render a range of numeric options with an empty label" do
      class SampleStep < Step
        step_attributes(:how_many)
      end

      sample = SampleStep.new
      form = MbFormBuilder.new("sample", sample, template, {})
      output = form.mb_select(
        :how_many,
        "",
        (0..10).map { |number| [pluralize(number, "thing"), number] },
      )
      expect(output).to be_html_safe

      expect(output).to match_html <<-HTML
        <div class="form-group">
          <label for="sample_how_many">
            <p class="form-question"></p>
          </label>
          <div class="select">
            <select class="select__element" name="sample[how_many]" id="sample_how_many">
              <option value="0">0 things</option>
              <option value="1">1 thing</option>
              <option value="2">2 things</option>
              <option value="3">3 things</option>
              <option value="4">4 things</option>
              <option value="5">5 things</option>
              <option value="6">6 things</option>
              <option value="7">7 things</option>
              <option value="8">8 things</option>
              <option value="9">9 things</option>
              <option value="10">10 things</option>
            </select>
          </div>
        </div>
      HTML
    end
  end
end
