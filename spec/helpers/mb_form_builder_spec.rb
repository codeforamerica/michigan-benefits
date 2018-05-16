require "rails_helper"

RSpec.describe MbFormBuilder do
  let(:template) do
    template = OpenStruct.new(output_buffer: "")
    template.extend ActionView::Helpers::FormHelper
    template.extend ActionView::Helpers::DateHelper
    template.extend ActionView::Helpers::FormTagHelper
    template.extend ActionView::Helpers::FormOptionsHelper
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
            <p class="form-question" id="sample_name__label">How is name?</p>
          </label>
          <input type="text" class="text-input" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" id="sample_name" aria-labelledby="sample_name__label" name="sample[name]" />
        </div>
      HTML
    end

    it "adds help text and error ids to aria-labelledby" do
      class SampleStep < Step
        step_attributes(:name)
        validates_presence_of :name
      end
      sample = SampleStep.new
      sample.validate

      form = MbFormBuilder.new("sample", sample, template, {})
      output = form.mb_input_field(
        :name,
        "How is name?",
        help_text: "Name is name",
      )
      expect(output).to be_html_safe
      expect(output).to match_html <<-HTML
        <div class="form-group form-group--error">
          <div class="field_with_errors">
            <label for="sample_name">
              <p class="form-question" id="sample_name__label">How is name?</p>
              <p class="text--help" id="sample_name__help">Name is name</p>
            </label>
          </div>
          <div class="field_with_errors">
            <input type="text" class="text-input" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" id="sample_name" aria-labelledby="sample_name__errors sample_name__label sample_name__help" name="sample[name]" />
          </div>
          <span class="text--error" id="sample_name__errors"><i class="icon-warning"></i> can't be blank </div>
        </div>
      HTML
    end
  end

  describe "#mb_incrementer" do
    it "renders an incrementer with screenreader-only labels" do
      class SampleStep < Step
        step_attributes(:dog)
      end

      sample = SampleStep.new
      form = MbFormBuilder.new("sample", sample, template, {})
      output = form.mb_incrementer(
        :dog,
        "How many puppies?",
        classes: ["dog-styles"],
      )
      expect(output).to be_html_safe
      expect(output).to match_html <<-HTML
        <div class="form-group">
          <label class="sr-only" for="sample_dog">How many puppies?</label>
          <div class="incrementer">
            <input type="number" class="dog-styles text-input form-width--short" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" id="sample_dog" name="sample[dog]" />
            <span class="incrementer__subtract">-</span>
            <span class="incrementer__add">+</span>
          </div>
        </div>
      HTML
    end

    it "displays errors" do
      class SampleStep < Step
        step_attributes(:dog)
        validates_presence_of :dog
      end
      sample = SampleStep.new
      sample.validate

      form = MbFormBuilder.new("sample", sample, template, {})
      output = form.mb_incrementer(
        :dog,
        "How many puppies?",
        classes: ["dog-styles"],
      )
      expect(output).to be_html_safe

      expect(output).to match_html <<-HTML
        <div class="form-group form-group--error">
          <div class="field_with_errors">
            <label class="sr-only" for="sample_dog">How many puppies?</label>
          </div>
          <div class="incrementer">
            <div class="field_with_errors">
              <input type="number" class="dog-styles text-input form-width--short" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" id="sample_dog" name="sample[dog]" />
            </div>
            <span class="incrementer__subtract">-</span>
            <span class="incrementer__add">+</span>
          </div>
          <span class="text--error" id="sample_dog__errors"><i class="icon-warning"></i> can't be blank </span>
        </div>
      HTML
    end

    context "when value is an array on the model" do
      it "renders an accessible incrementer" do
        class SampleStep < Step
          step_attributes(dogs: [])
        end

        sample = SampleStep.new
        form = MbFormBuilder.new("sample", sample, template, {})
        output = form.mb_incrementer(
          :dogs,
          "How many puppies?",
          value_is_array: true,
          value: 3,
          id_suffix: "greyhound",
        )
        expect(output).to be_html_safe
        expect(output).to match_html <<-HTML
          <div class="form-group">
            <label class="sr-only" for="sample_dogs_greyhound">How many puppies?</label>
            <div class="incrementer">
              <input type="number" class="text-input form-width--short" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" id="sample_dogs_greyhound" multiple="multiple" value="3" name="sample[dogs][]" />
              <span class="incrementer__subtract">-</span>
              <span class="incrementer__add">+</span>
            </div>
          </div>
        HTML
      end
    end
  end

  describe "#mb_textarea" do
    it "renders a label with the sr-only class when hide_label set to true" do
      class SampleStep < Step
        step_attributes(:description)
        validates_presence_of :description
      end
      sample = SampleStep.new
      sample.validate

      form = MbFormBuilder.new("sample", sample, template, {})
      output = form.mb_textarea(
        :description,
        "Write a lot?",
        help_text: "Name for texting",
        hide_label: true,
      )
      expect(output).to be_html_safe
      expect(output).to match_html <<-HTML
        <div class="form-group form-group--error">
         <div class="field_with_errors">
           <label class="sr-only" for="sample_description">
             <p class="form-question" id="sample_description__label">Write a lot?</p>
             <p class="text--help" id="sample_description__help">Name for texting</p>
           </label>
         </div>
         <div class="field_with_errors">
           <textarea class="textarea" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" aria-labelledby="sample_description__errors sample_description__label sample_description__help" name="sample[description]" id="sample_description"></textarea>
         </div>
         <span class="text--error" id="sample_description__errors"><i class="icon-warning"></i> can't be blank </span>
       </div>
      HTML
    end
  end

  describe "#mb_phone_number_field" do
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
            <p class="form-question" id="sample_phone_number__label">What is phone?</p>
          </label>
          <div class="text-input-group">
            <div class="text-input-group__prefix">+1</div>
            <input type="tel" class="text-input" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"  maxlength="10" id="sample_phone_number" aria-labelledby="sample_phone_number__label" size="10" name="sample[phone_number]" />
          </div>
        </div>
      HTML
    end
  end

  describe "#mb_select" do
    it "renders a range of numeric options with a screen-reader only label" do
      class SampleStep < Step
        step_attributes(:how_many)
        validates_presence_of :how_many
      end

      sample = SampleStep.new
      sample.validate
      form = MbFormBuilder.new("sample", sample, template, {})
      output = form.mb_select(
        :how_many,
        "This is for screen readers!",
        (0..10).map { |number| [pluralize(number, "thing"), number] },
        hide_label: true,
        help_text: "Choose how many",
      )
      expect(output).to be_html_safe

      expect(output).to match_html <<-HTML
        <div class="form-group form-group--error">
          <div class="field_with_errors">
            <label class="sr-only" for="sample_how_many">
              <p class="form-question" id="sample_how_many__label">This is for screen readers!</p>
              <p class="text--help" id="sample_how_many__help">Choose how many</p>
            </label>
          </div>
          <div class="select">
            <div class="field_with_errors">
              <select class="select__element" aria-labelledby="sample_how_many__errors sample_how_many__label sample_how_many__help" name="sample[how_many]" id="sample_how_many">
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
          <span class="text--error" id="sample_how_many__errors"><i class="icon-warning"></i> can't be blank </span>
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
      form = MbFormBuilder.new(:sample, sample, template, {})
      output = form.mb_date_select(
        :birthday,
        "What is your birthday?",
        help_text: "(For surprises)",
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
          <legend class="form-question " id="sample_birthday__label"> What is your birthday? </legend>
          <p class="text--help" id="sample_birthday__help">(For surprises)</p>
          <div class="input-group--inline">
            <div class="select">
              <label for="sample_birthday_2i" class="sr-only" id="sample_birthday_2i__label">Month</label>
              <select id="sample_birthday_2i" name="sample[birthday(2i)]" class="select__element" aria-labelledby="sample_birthday__label sample_birthday__help sample_birthday_2i__label">
                <option value="">Month</option>
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
              <label for="sample_birthday_3i" class="sr-only" id="sample_birthday_3i__label">Day</label>
              <select id="sample_birthday_3i" name="sample[birthday(3i)]" class="select__element" aria-labelledby="sample_birthday__label sample_birthday__help sample_birthday_3i__label">
                <option value="">Day</option>
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
              <label for="sample_birthday_1i" class="sr-only" id="sample_birthday_1i__label">Year</label>
              <select id="sample_birthday_1i" name="sample[birthday(1i)]" class="select__element" aria-labelledby="sample_birthday__label sample_birthday__help sample_birthday_1i__label">
                <option value="">Year</option>
                <option value="1990" selected="selected">1990</option>
                <option value="1991">1991</option>
                <option value="1992">1992</option>
              </select>
            </div>
          </div>
        </fieldset>
      HTML
    end

    it "renders an accessible many member date select" do
      class SampleManyStep < ManyMembersStep
        step_attributes :members
      end

      medicaid_app = create(
        :medicaid_application,
        anyone_other_income: true,
      )

      sample = SampleManyStep.new(
        members: [create(:member, id: 72, benefit_application: medicaid_app)],
      )
      member = sample.members.first
      form = MbFormBuilder.new(:sample, sample, template, {})

      output = form.fields_for("members[]",
                               member,
                               builder: MbFormBuilder) do |ff|
        ff.mb_date_select(
          :birthday,
          "What is your birthday?",
          help_text: "(For surprises)",
          options: {
            start_year: 1990,
            end_year: 1992,
            default: Date.new(1990, 3, 25),
            order: %i{month day year},
          },
        )
      end

      expect(output).to be_html_safe

      expect(output).to match_html <<-HTML
        <fieldset class="form-group">
          <legend class="form-question " id="sample_members_72_birthday__label"> What is your birthday? </legend>
          <p class="text--help" id="sample_members_72_birthday__help">(For surprises)</p>
          <div class="input-group--inline">
            <div class="select">
              <label for="sample_members_72_birthday_2i" class="sr-only" id="sample_members_72_birthday_2i__label">Month</label>
              <select id="sample_members_72_birthday_2i" name="sample[members][72][birthday(2i)]" class="select__element" aria-labelledby="sample_members_72_birthday__label sample_members_72_birthday__help sample_members_72_birthday_2i__label">
                <option value="">Month</option>
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
              <label for="sample_members_72_birthday_3i" class="sr-only" id="sample_members_72_birthday_3i__label">Day</label>
              <select id="sample_members_72_birthday_3i" name="sample[members][72][birthday(3i)]" class="select__element" aria-labelledby="sample_members_72_birthday__label sample_members_72_birthday__help sample_members_72_birthday_3i__label">
                <option value="">Day</option>
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
              <label for="sample_members_72_birthday_1i" class="sr-only" id="sample_members_72_birthday_1i__label">Year</label>
              <select id="sample_members_72_birthday_1i" name="sample[members][72][birthday(1i)]" class="select__element" aria-labelledby="sample_members_72_birthday__label sample_members_72_birthday__help sample_members_72_birthday_1i__label">
                <option value="">Year</option>
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

  describe "#mb_date_input" do
    it "renders an accessible trio of text fields for month, day, and year" do
      class SampleStep < Step
        step_attributes(:birthday_year)
        step_attributes(:birthday_month)
        step_attributes(:birthday_day)
      end

      sample = SampleStep.new
      form = MbFormBuilder.new(:sample, sample, template, {})
      output = form.mb_date_input(
        :birthday,
        "What is your birthday?",
        help_text: "(For surprises)",
      )
      expect(output).to be_html_safe

      expect(output).to match_html <<-HTML
      <fieldset class="form-group">
        <legend class="form-question " id="sample_birthday__label"> What is your birthday? </legend>
        <p class="text--help" id="sample_birthday__help">(For surprises)</p>
        <div class="input-group--inline">
          <div class="form-group">
            <label class="text--help form-subquestion" for="sample_birthday_month" id="sample_birthday_month__label">Month</label>
            <input class="form-width--month text-input" id="sample_birthday_month" name="sample[birthday_month]" size="2" minlength="1" maxlength="2" type="tel" />
          </div>
          <div class="form-group">
            <label class="text--help form-subquestion" for="sample_birthday_day" id="sample_birthday_day__label">Day</label>
            <input class="form-width--day text-input" id="sample_birthday_day" name="sample[birthday_day]" size="2" minlength="1" maxlength="2" type="tel" />
          </div>
          <div class="form-group">
            <label class="text--help form-subquestion" for="sample_birthday_year" id="sample_birthday_year__label">Year</label>
            <input class="form-width--year text-input" id="sample_birthday_year" name="sample[birthday_year]" size="4" minlength="4" maxlength="4" type="tel" />
          </div>
        </div>
      </fieldset>
      HTML
    end

    it "displays errors on the containing field" do
      class SampleForm < Form
        set_attributes_for :member,
          :birthday_year,
          :birthday_month,
          :birthday_day

        validate :birthday_should_be_valid

        def birthday_should_be_valid
          errors.add(:birthday, "Not a great birthday tbh")
        end
      end

      sample = SampleForm.new

      expect(sample).not_to be_valid

      form = MbFormBuilder.new(:sample, sample, template, {})
      output = form.mb_date_input(
        :birthday,
        "What is your birthday?",
        help_text: "(For surprises)",
      )

      expect(output).to be_html_safe

      expect(output).to include_html <<-HTML
        <span class="text--error" id="sample_birthday__errors"><i class="icon-warning"></i> Not a great birthday tbh </div>
      HTML
    end
  end

  describe "#mb_radio_set" do
    it "renders an accessible set of radio inputs" do
      class SampleStep < Step
        step_attributes(:dependent_care)
        validates_presence_of :dependent_care
      end

      sample = SampleStep.new
      sample.validate
      form = MbFormBuilder.new("sample", sample, template, {})
      output = form.mb_radio_set(
        :dependent_care,
        label_text: "Does your household have dependent care expenses?",
        collection: [
          { label: "Yep", value: true, options: { "data-follow-up": "#yep-follow-up" } },
          { label: "Nope", value: false },
        ],
        help_text: "This includes child care.",
      )
      expect(output).to be_html_safe

      expect(output).to match_html <<-HTML
        <fieldset class="form-group form-group--error">
          <legend class="form-question " id="sample_dependent_care__label">
            Does your household have dependent care expenses?
          </legend>
          <p class="text--help" id="sample_dependent_care__help">This includes child care.</p>
          <radiogroup class="input-group--block">
            <label class="radio-button" id="sample_dependent_care_true__label"><div class="field_with_errors"><input aria-labelledby="sample_dependent_care__errors sample_dependent_care__label sample_dependent_care__help sample_dependent_care_true__label" data-follow-up="#yep-follow-up" type="radio" value="true" name="sample[dependent_care]" id="sample_dependent_care_true"/></div> Yep </label>
            <label class="radio-button" id="sample_dependent_care_false__label"><div class="field_with_errors"><input aria-labelledby="sample_dependent_care__errors sample_dependent_care__label sample_dependent_care__help sample_dependent_care_false__label" type="radio" value="false" name="sample[dependent_care]" id="sample_dependent_care_false"/></div> Nope </label>
          </radiogroup>
          <span class="text--error" id="sample_dependent_care__errors"><i class="icon-warning"></i> can't be blank </span>
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
        :captains,
        [
          { method: :tng, label: "Picard" },
          { method: :ds9, label: "Sisko" },
          { method: :voyager, label: "Janeway" },
          { method: :tos, label: "Kirk" },
        ],
        label_text: "Which captains do you think are cool?",
        help_text: "like, really cool",
      )

      expect(output).to be_html_safe

      expect(output).to match_html <<-HTML
        <fieldset class="input-group">
          <legend class="form-question " id="sample_captains__label"> Which captains do you think are cool? </legend>
          <p class="text--help" id="sample_captains__help">like, really cool</p>
          <label id="sample_captains_tng__label" class="checkbox"><input name="sample[tng]" type="hidden" value="0" /><input aria-labelledby="sample_captains__label sample_captains__help sample_captains_tng__label" type="checkbox" value="1" name="sample[tng]" id="sample_tng"/> Picard </label>
          <label id="sample_captains_ds9__label" class="checkbox"><input name="sample[ds9]" type="hidden" value="0" /><input aria-labelledby="sample_captains__label sample_captains__help sample_captains_ds9__label" type="checkbox" value="1" name="sample[ds9]" id="sample_ds9"/> Sisko </label>
          <label id="sample_captains_voyager__label" class="checkbox"><input name="sample[voyager]" type="hidden" value="0" /><input aria-labelledby="sample_captains__label sample_captains__help sample_captains_voyager__label" type="checkbox" value="1" name="sample[voyager]" id="sample_voyager"/> Janeway </label>
          <label id="sample_captains_tos__label" class="checkbox"><input name="sample[tos]" type="hidden" value="0" /><input aria-labelledby="sample_captains__label sample_captains__help sample_captains_tos__label" type="checkbox" value="1" name="sample[tos]" id="sample_tos"/> Kirk </label>
        </fieldset>
      HTML
    end
  end

  describe "#mb_checkbox_set_with_none" do
    it "renders an accessible set of checkbox inputs" do
      class SampleStep < Step
        step_attributes(
          :tng,
          :voyager,
        )
      end

      sample = SampleStep.new(tng: true)
      form = MbFormBuilder.new("sample", sample, template, {})
      output = form.mb_checkbox_set_with_none(
        :captains,
        [
          { method: :tng, label: "Picard" },
          { method: :voyager, label: "Janeway" },
        ],
        label_text: "Which captains do you think are cool?",
      )

      expect(output).to be_html_safe

      expect(output).to match_html <<-HTML
        <fieldset class="input-group">
          <legend class="sr-only" id="sample_captains__label"> Which captains do you think are cool? </legend>
          <label id="sample_tng__label" class="checkbox"><input name="sample[tng]" type="hidden" value="0" /><input aria-labelledby="sample_captains__label sample_tng__label" type="checkbox" value="1" checked="checked" name="sample[tng]" id="sample_tng" /> Picard </label>
          <label id="sample_voyager__label" class="checkbox"><input name="sample[voyager]" type="hidden" value="0" /><input aria-labelledby="sample_captains__label sample_voyager__label" type="checkbox" value="1" name="sample[voyager]" id="sample_voyager" /> Janeway </label>
          <hr />
          <label class="checkbox" id="none__label"><input aria-labelledby="sample_captains__label none__label" type="checkbox" name="" class="" id="none__checkbox" /> None of the above </label>
        </fieldset>
      HTML
    end

    context "when value is an array on the model" do
      it "renders an accessible set of checkbox inputs" do
        class SampleStep < Step
          step_attributes(
            captains: [],
          )
        end

        sample = SampleStep.new(captains: ["tng"])
        form = MbFormBuilder.new("sample", sample, template, {})
        output = form.mb_checkbox_set_with_none(
          :captains,
          [
            { method: :tng, label: "Picard" },
            { method: :ds9, label: "Sisko" },
          ],
          label_text: "Which captains do you think are cool?",
          value_is_array: true,
        )

        expect(output).to be_html_safe

        expect(output).to match_html <<-HTML
          <fieldset class="input-group">
            <legend class="sr-only" id="sample_captains__label"> Which captains do you think are cool? </legend>
            <label id="sample_tng__label" class="checkbox"><input name="sample[captains][]" type="hidden" value="" /><input aria-labelledby="sample_captains__label sample_tng__label" type="checkbox" value="tng" checked="checked" name="sample[captains][]" id="sample_captains_tng" /> Picard </label>
            <label id="sample_ds9__label" class="checkbox"><input name="sample[captains][]" type="hidden" value="" /><input aria-labelledby="sample_captains__label sample_ds9__label" type="checkbox" value="ds9" name="sample[captains][]" id="sample_captains_ds9" /> Sisko </label>
            <hr />
            <label class="checkbox" id="none__label"><input aria-labelledby="sample_captains__label none__label" type="checkbox" name="" class="" id="none__checkbox" /> None of the above </label>
          </fieldset>
        HTML
      end
    end
  end

  describe "#mb_checkbox" do
    it "renders an accessible checkbox input" do
      class SampleStep < Step
        step_attributes(:read_tos)
        validates_presence_of :read_tos
      end

      sample = SampleStep.new
      sample.validate
      form = MbFormBuilder.new("sample", sample, template, {})
      output = form.mb_checkbox(
        :read_tos,
        "Confirm that you agree to Terms of Service",
      )

      expect(output).to be_html_safe

      expect(output).to match_html <<-HTML
        <label class="checkbox" id="sample_read_tos__label">
          <input name="sample[read_tos]" type="hidden" value="0" />
          <div class="field_with_errors">
            <input aria-labelledby="sample_read_tos__errors sample_read_tos__label" type="checkbox" value="1" name="sample[read_tos]" id="sample_read_tos" />
          </div>
          Confirm that you agree to Terms of Service
        </label>
        <span class="text--error" id="sample_read_tos__errors">
          <i class="icon-warning"></i> can't be blank
        </span>
      HTML
    end

    it "prefixes aria-labelledby with custom legend id" do
      class SampleStep < Step
        step_attributes(:read_tos)
      end

      sample = SampleStep.new
      form = MbFormBuilder.new("sample", sample, template, {})
      output = form.mb_checkbox(
        :read_tos,
        "Confirm that you agree to Terms of Service",
        legend_id: "legend__label",
      )

      expect(output).to be_html_safe

      expect(output).to match_html <<-HTML
        <label class="checkbox" id="sample_read_tos__label">
          <input name="sample[read_tos]" type="hidden" value="0" />
          <input aria-labelledby="legend__label sample_read_tos__label" type="checkbox" value="1" name="sample[read_tos]" id="sample_read_tos" />
          Confirm that you agree to Terms of Service
        </label>
      HTML
    end

    context "when checkbox is disabled and value is equal to checked value" do
      it "renders disabled checkbox as selected" do
        class SampleStep < Step
          step_attributes(:read_tos)
        end

        sample = SampleStep.new(read_tos: "yes")
        form = MbFormBuilder.new("sample", sample, template, {})
        output = form.mb_checkbox(:read_tos,
          "Confirm that you agree to Terms of Service",
          options: {
            checked_value: "yes",
            unchecked_value: "no",
            disabled: true,
          })

        expect(output).to be_html_safe

        expect(output).to match_html <<-HTML
        <label class="checkbox is-selected" id="sample_read_tos__label">
          <input name="sample[read_tos]" disabled="disabled" type="hidden" value="no" />
          <input checked_value="yes" unchecked_value="no" disabled="disabled" aria-labelledby="sample_read_tos__label" type="checkbox" value="yes" checked="checked" name="sample[read_tos]" id="sample_read_tos" />
          Confirm that you agree to Terms of Service
        </label>
        HTML
      end
    end
  end

  describe "#mb_yes_no_buttons" do
    it "returns valid submit buttons" do
      class SampleForm < Form
        set_attributes_for :application, :lives_in_michigan
      end

      sample = SampleForm.new
      form = MbFormBuilder.new("form", sample, template, {})
      output = form.mb_yes_no_buttons(:lives_in_michigan)

      expect(output).to be_html_safe

      expect(output).to match_html <<-HTML
        <div class="form-card__buttons">
          <div>
            <button class="button button--nav button--full-mobile" type="submit" value="false" name="form[lives_in_michigan]">
              No
            </button>
          </div>
          <div>
            <button class="button button--nav button--full-mobile button--cta" type="submit" value="true" name="form[lives_in_michigan]">
              Yes
            </button>
          </div>
        </div>
      HTML
    end

    it "accepts alternate values for inputs" do
      class SampleForm < Form
        set_attributes_for :application, :lives_in_michigan
      end

      sample = SampleForm.new
      form = MbFormBuilder.new("form", sample, template, {})
      output = form.mb_yes_no_buttons(:lives_in_michigan, yes_value: "truthy", no_value: "falsy")

      expect(output).to be_html_safe

      expect(output).to match_html <<-HTML
        <div class="form-card__buttons">
          <div>
            <button class="button button--nav button--full-mobile" type="submit" value="falsy" name="form[lives_in_michigan]">
              No
            </button>
          </div>
          <div>
            <button class="button button--nav button--full-mobile button--cta" type="submit" value="truthy" name="form[lives_in_michigan]">
              Yes
            </button>
          </div>
        </div>
      HTML
    end
  end
end
