# TODO delete
class DummyFinalStep < Step
  self.title = "Final"
  self.subhead = "Thanks for submitting"

  def static_template
    "steps/dummy_final_step"
  end

  def previous
    SignAndSubmit.new(@app)
  end

  def next
    "/"
  end

  def assign_from_app
  end

  def update_app!
  end
end
