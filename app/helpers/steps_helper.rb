module StepsHelper
  def header_name(household_member)
    name = household_member.first_name.titleize
    household_member.primary_member? ? "#{name} (that’s you!)" : name
  end
end
