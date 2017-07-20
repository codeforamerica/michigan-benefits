# frozen_string_literal: true

class PreferencesForInterview < Step
  step_attributes :preference_for_interview

  validates :preference_for_interview,
    presence: { message: 'Make sure to answer this question' }
end
