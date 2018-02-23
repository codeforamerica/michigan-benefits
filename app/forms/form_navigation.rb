class FormNavigation
  MAIN = {
    "Introduction" => [
      Integrated::IntroduceYourselfController,
      Integrated::BenefitsIntroController,
    ],
  }.freeze

  OFF_MAIN = {}.freeze

  class << self
    delegate :first, to: :forms

    def forms_with_groupings
      MAIN
    end

    def forms
      @forms ||= MAIN.values.flatten.freeze
    end

    def all
      (MAIN.values + OFF_MAIN.values).flatten.freeze
    end
  end

  delegate :forms, to: :class

  def initialize(form_controller)
    @controller = form_controller
  end

  def next
    return unless index
    forms_until_end = forms[index + 1..-1]
    seek(forms_until_end)
  end

  def previous
    return unless index
    return if index.zero?
    forms_to_beginning = forms[0..index - 1].reverse
    seek(forms_to_beginning)
  end

  def index
    forms.index(@controller.class)
  end

  private

  def seek(list)
    list.detect do |controller_class|
      !controller_class.skip?(@controller.current_application)
    end
  end
end
