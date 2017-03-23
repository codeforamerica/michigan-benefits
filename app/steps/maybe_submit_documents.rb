class MaybeSubmitDocuments < Step
  include Rails.application.routes.url_helpers

  self.title = "Submit Documents"
  self.subhead = "Do you have any documents you can submit now?"

  def static_template
    "steps/maybe_submit_documents"
  end

  def previous
    nil
  end

  def next
    nil
  end

  def assign_from_app
  end

  def update_app!
  end
end
