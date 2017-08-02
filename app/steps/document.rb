# frozen_string_literal: true

class Document < Step
  step_attributes(
    :document,
    documents: [],
  )

  validates :documents,
    presence: { message: "Make sure to upload some documents" }
end
