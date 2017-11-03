module MedicaidApplicationFormHelper
  def enter_dob_and_ssn(display_name:, last_four_ssn:)
    within(".household-member-group[data-member-name='#{display_name}']") do
      select("January")
      select("1")
      select("1969")
      fill_in "Social Security Number (last 4 digits)", with: last_four_ssn
    end
  end
end
