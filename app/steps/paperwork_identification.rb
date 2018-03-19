class PaperworkIdentification < Step
  step_attributes(:has_picture_id_for_everyone)

  validates :has_picture_id_for_everyone,
    presence: { message: "Make sure to answer this question" }
end
