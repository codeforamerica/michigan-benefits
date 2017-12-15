class AuthorizedRepresentative < Step
  step_attributes(
    :authorized_representative,
    :authorized_representative_name,
  )

  validates(
    :authorized_representative,
    presence: { message: "Make sure to answer this question" },
  )
  validate :name_present_if_authorized_rep_true

  def name_present_if_authorized_rep_true
    return true if authorized_representative == "false" ||
        authorized_representative.nil?
    return true if authorized_representative &&
        authorized_representative_name.present?
    errors.add(
      :authorized_representative_name,
      "Make sure to enter your legal representative's full name",
    )
  end
end
