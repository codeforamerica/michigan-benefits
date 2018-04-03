class WhoIs<%= model_name %>Form < Form
  set_application_attributes(:members)
  set_member_attributes(:<%= model_method %>)

  validate :at_least_one_person

  def at_least_one_person
    return true if members.any?(&:<%= model_method %>_yes?)
    errors.add(:members, "Make sure you select at least one person")
  end
end
