require "rails_helper"

RSpec.describe MbFormBuilder do
  let(:template) do
    template = OpenStruct.new(output_buffer: "")
    template.extend ActionView::Helpers::FormHelper
    template.extend ActionView::Helpers::DateHelper
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

  describe "#mb_date_select" do
    it "renders an accessible date select" do
      class SampleStep < Step
        step_attributes(:birthday)
      end

      sample = SampleStep.new
      form = MbFormBuilder.new("sample", sample, template, {})
      output = form.mb_date_select(
        :birthday,
        "What is your birthday?",
        notes: ["(For surprises)"],
        options: {
          start_year: 1990,
          end_year: 1992,
          default: Date.new(1990, 3, 25),
          order: %i{month day year},
        },
      )
      expect(output).to be_html_safe

      expect(output).to match_html <<-HTML
        <fieldset class="form-group">
          <legend class="form-question ">What is your birthday?</legend>
          <p class="text--help">(For surprises)</p>
          <div class="input-group--inline">
            <div class="select">
              <label for="sample_birthday_2i" class="sr-only">Month</label>
              <select id="sample_birthday_2i" name="sample[birthday(2i)]" class="select__element">
                <option value="1">January</option>
                <option value="2">February</option>
                <option value="3" selected="selected">March</option>
                <option value="4">April</option>
                <option value="5">May</option>
                <option value="6">June</option>
                <option value="7">July</option>
                <option value="8">August</option>
                <option value="9">September</option>
                <option value="10">October</option>
                <option value="11">November</option>
                <option value="12">December</option>
              </select>
            </div>
            <div class="select">
              <label for="sample_birthday_3i" class="sr-only">Day</label>
              <select id="sample_birthday_3i" name="sample[birthday(3i)]" class="select__element">
                <option value="1">1</option>
                <option value="2">2</option>
                <option value="3">3</option>
                <option value="4">4</option>
                <option value="5">5</option>
                <option value="6">6</option>
                <option value="7">7</option>
                <option value="8">8</option>
                <option value="9">9</option>
                <option value="10">10</option>
                <option value="11">11</option>
                <option value="12">12</option>
                <option value="13">13</option>
                <option value="14">14</option>
                <option value="15">15</option>
                <option value="16">16</option>
                <option value="17">17</option>
                <option value="18">18</option>
                <option value="19">19</option>
                <option value="20">20</option>
                <option value="21">21</option>
                <option value="22">22</option>
                <option value="23">23</option>
                <option value="24">24</option>
                <option value="25" selected="selected">25</option>
                <option value="26">26</option>
                <option value="27">27</option>
                <option value="28">28</option>
                <option value="29">29</option>
                <option value="30">30</option>
                <option value="31">31</option>
              </select>
            </div>
            <div class="select">
              <label for="sample_birthday_1i" class="sr-only">Year</label>
              <select id="sample_birthday_1i" name="sample[birthday(1i)]" class="select__element">
                <option value="1990" selected="selected">1990</option>
                <option value="1991">1991</option>
                <option value="1992">1992</option>
              </select>
            </div>
          </div>
        </fieldset>
      HTML
    end
  end

  describe "#mb_radio_set" do
    it "renders an accessible set of radio inputs" do
      class SampleStep < Step
        step_attributes(:dependent_care)
      end

      sample = SampleStep.new
      form = MbFormBuilder.new("sample", sample, template, {})
      output = form.mb_radio_set(
        :dependent_care,
        "Does your household have dependent care expenses?",
        [{ label: "Yep", value: true }, { label: "Nope", value: false }],
        notes: <<~NOTE
          This includes child care (including day care and after school
          programs) and adult disabled care.
        NOTE
      )
      expect(output).to be_html_safe

      expect(output).to match_html <<-HTML
        <fieldset class="form-group">
          <legend class="form-question ">Does your household have dependent care expenses?</legend>
          <p class="text--help">This includes child care (including day care and after school programs) and adult disabled care. </p>
          <radiogroup class="input-group--block">
            <label class="radio-button"><input type="radio" value="true" name="sample[dependent_care]" id="sample_dependent_care_true" /> Yep </label>
            <label class="radio-button"><input type="radio" value="false" name="sample[dependent_care]" id="sample_dependent_care_false" /> Nope </label>
          </radiogroup>
        </fieldset>
      HTML
    end
  end

  describe "#mb_checkbox_set" do
    it "renders an accessible set of checkbox inputs" do
      class SampleStep < Step
        step_attributes(
          :tng,
          :ds9,
          :voyager,
          :tos,
        )
      end

      sample = SampleStep.new
      form = MbFormBuilder.new("sample", sample, template, {})
      output = form.mb_checkbox_set(
        [
          { method: :tng, label: "Picard" },
          { method: :ds9, label: "Sisko" },
          { method: :voyager, label: "Janeway" },
          { method: :tos, label: "Kirk" },
        ],
        label_text: "Which captains do you think are cool?",
      )

      expect(output).to be_html_safe

      expect(output).to match_html <<-HTML
        <fieldset class="input-group">
          <legend class="form-question ">Which captains do you think are cool?</legend>
          <label class="checkbox"><input name="sample[tng]" type="hidden" value="0" /><input type="checkbox" value="1" name="sample[tng]" id="sample_tng" /> Picard </label>
          <label class="checkbox"><input name="sample[ds9]" type="hidden" value="0" /><input type="checkbox" value="1" name="sample[ds9]" id="sample_ds9" /> Sisko </label>
          <label class="checkbox"><input name="sample[voyager]" type="hidden" value="0" /><input type="checkbox" value="1" name="sample[voyager]" id="sample_voyager" /> Janeway </label>
          <label class="checkbox"><input name="sample[tos]" type="hidden" value="0" /><input type="checkbox" value="1" name="sample[tos]" id="sample_tos" /> Kirk </label>
        </fieldset>
      HTML
    end
  end
end
