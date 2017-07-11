module SimpleStepHelper
  def back_path
    previous = StepNavigation.new(@step).previous
    previous ? step_path(previous.to_param) : root_path
  end

  def icon(name)
    haml_tag "div.step-section-header__icon.illustration.illustration--#{name}"
  end
end
