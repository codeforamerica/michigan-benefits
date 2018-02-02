require "rails_helper"

RSpec.feature "viewing Numbers dashboard" do
  before do
    create_list(:snap_application, 3, :signed)
    create_list(:medicaid_application, 2, :signed)

    login_with_basic_auth
  end

  scenario "viewing total SNAP and Medicaid apps submitted" do
    visit numbers_path

    expect(page).to have_content("Completed Applications")

    within "#total-snap-applications" do
      expect(page).to have_content("Total SNAP")
      expect(page).to have_content("3")
    end

    within "#total-medicaid-applications" do
      expect(page).to have_content("Total Medicaid")
      expect(page).to have_content("2")
    end

    expect(page).to have_content("Median Minutes to Complete (last 30 days)")

    within "#snap-time-to-complete" do
      expect(page).to have_content("SNAP")
    end

    within "#medicaid-time-to-complete" do
      expect(page).to have_content("Medicaid")
    end
  end
end
