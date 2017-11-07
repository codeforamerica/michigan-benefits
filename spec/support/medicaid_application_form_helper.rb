module MedicaidApplicationFormHelper
  def enter_dob_and_ssn(display_name:, ssn:)
    within(".household-member-group[data-member-name='#{display_name}']") do
      select("January")
      select("1")
      select("1969")
      fill_in "Social Security Number", with: ssn
    end
  end
end
