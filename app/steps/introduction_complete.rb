class IntroductionComplete < Step
  self.icon = "hello"
  self.title = "Introduction"
  self.subhead = "It should take about 10 more minutes to complete a "\
    "full application."

  def initialize(*args)
    super
    self.headline = "Thank you #{@app.first_name}"
  end

  def static_template
    "steps/introduction_complete"
  end

  def previous
    HomeAddress.new(@app)
  end

  def next
    "/"
  end

  def assign_from_app
  end

  def update_app!
  end
end
