require "rails_helper"

RSpec.feature "viewing Numbers dashboard" do
  before do
    create_list(:snap_application, 3, :signed)
    create_list(:medicaid_application, 2, :signed)
  end

  scenario "viewing total SNAP and Medicaid apps submitted" do
    visit numbers_path

    within "#total-snap-applications" do
      expect(page).to have_content("Total Completed SNAP Applications")
      expect(page).to have_content("3")
    end

    within "#total-medicaid-applications" do
      expect(page).to have_content("Total Completed Medicaid Applications")
      expect(page).to have_content("2")
    end
  end
end
