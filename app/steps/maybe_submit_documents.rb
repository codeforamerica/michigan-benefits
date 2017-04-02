class MaybeSubmitDocuments < Step
  include Rails.application.routes.url_helpers

  self.title = "Submit Documents"
  self.subhead = "Do you have any documents you can submit now?"
  self.subhead_help = "For example: ID, proof of income, proof of residency."

  def assign_from_app
  end

  def update_app!
  end
end
