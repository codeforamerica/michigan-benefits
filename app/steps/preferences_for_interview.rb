class PreferencesForInterview < Step
  self.title = "Preferences"
  self.subhead = "The next step after you apply is a brief interview "\
    "with your county."

  self.questions = {
    preference_for_interview: "What do you prefer?"
  }

  self.types = {
    preference_for_interview: :radios
  }

  self.field_options = {
    preference_for_interview: App::PREFERENCES_FOR_INTERVIEW.map(&:to_s)
  }

  attr_accessor :preference_for_interview

  def assign_from_app
    assign_attributes @app.attributes.slice(*%w[
      preference_for_interview
    ])
  end

  def update_app!
    @app.update!(
      preference_for_interview: preference_for_interview
    )
  end
end
