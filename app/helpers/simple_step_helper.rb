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

  def fields_for_each_member(f, household_members)
    household_members.each do |member|
      haml_concat(
        f.fields_for('household_members[]', member, hidden_field_id: true) do |ff|
          yield ff, member
        end
      )
    end
  end

  def data_md5(str)
    Digest::MD5.hexdigest(str.to_s.tr("\n", ' ').strip)
  end

  def inconsistent_members(household_members)
    household_members.with_inconsistent_income.map(&:name).to_sentence
  end
end
