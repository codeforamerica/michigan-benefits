class GeneralInterviewPreference < Step
  step_attributes(
    :interview_preference,
  )

  validates :interview_preference, inclusion: {
    in: %w(in_person telephone),
    message: "Make sure to answer this question",
  }
end
