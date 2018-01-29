module MedicaidApplicationFormHelper
  def enter_ssn(display_name:, ssn:)
    within(".household-member-group[data-member-name='#{display_name}']") do
      fill_in "Social Security Number", with: ssn
    end
  end
end
