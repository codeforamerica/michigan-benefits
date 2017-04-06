class PreferencesAnythingElse < Step
  self.title = "Preferences"
  self.subhead = "Is there anything else you'd like us to know about your situation?"
  self.subhead_help = "Feel free to give other details you think might be helpful for us to know. Otherwise, you can skip this question."

  attr_accessor :anything_else

  def assign_from_app
    assign_attributes @app.attributes.slice(*%w[
      anything_else
    ])
  end

  def update_app!
    @app.update!(
      anything_else: anything_else
    )
  end

  def allowed_params
    [ :anything_else ]
  end


end
