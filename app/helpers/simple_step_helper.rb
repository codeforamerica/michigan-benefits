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

  def header_name(household_member)
    name = household_member.first_name.titleize
    household_member.applicant? ? "#{name} (that’s you!)" : name
  end
end
