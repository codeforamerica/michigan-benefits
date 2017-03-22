class HomeAddress < Step
  self.title = "Introduction"
  self.subhead = "Tell us where you currently live."

  def previous
    ContactInformation.new(@app)
  end

  def next
    "/"
  end

  def assign_from_app
    assign_attributes @app.attributes.slice(*%w[
    ])
  end

  def update_app!
    @app.update!(
    )
  end
end
