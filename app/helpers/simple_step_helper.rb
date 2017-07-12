module SimpleStepHelper
  def icon(name)
    haml_tag "div.step-section-header__icon.illustration.illustration--#{name}"
  end
end
