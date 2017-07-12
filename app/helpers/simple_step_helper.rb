# frozen_string_literal: true

module SimpleStepHelper
  def icon(name)
    haml_tag "div.step-section-header__icon.illustration.illustration--#{name}"
  end

  def questions(f, questions)
    questions.each do |question|
      haml_concat render 'shared/question', f: f, **question
    end
  end
end
