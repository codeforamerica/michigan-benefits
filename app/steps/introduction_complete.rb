class IntroductionComplete < Step
  self.icon = "celebrate"
  self.title = "Introduction"
  self.subhead = "It should take about 10 more minutes to complete a "\
    "full application."

  def initialize(*args)
    super
    self.headline = "Thank you #{@app.applicant.first_name}!"
  end

  def assign_from_app
  end

  def update_app!
  end
end
