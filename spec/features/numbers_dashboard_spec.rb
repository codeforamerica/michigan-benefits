require "rails_helper"

RSpec.feature "viewing Numbers dashboard" do
  before do
    create_list(:snap_application, 3, :signed, :with_member)
    create_list(:medicaid_application, 2, :signed, :with_member)
    create_list(:common_application, 3, :signed, :multi_member_food_and_healthcare)
    create(:common_application, :signed, :multi_member_food)
    create(:common_application, :signed, :multi_member_healthcare)
    login_with_basic_auth
  end

  scenario "viewing total SNAP and Medicaid apps submitted" do
    visit numbers_path

    expect(page).to have_content("Completed Applications (10)")

    within "#total-combined-applications" do
      expect(page).to have_content("Integrated Flow")
      expect(page).to have_content("5")
    end

    within "#total-snap-applications" do
      expect(page).to have_content("Old SNAP Flow")
      expect(page).to have_content("3")
    end

    within "#total-medicaid-applications" do
      expect(page).to have_content("Old Medicaid Flow")
      expect(page).to have_content("2")
    end

    expect(page).to have_content("Completed Integrated Applications - By Type")

    within "#total-combined-snap-only" do
      expect(page).to have_content("SNAP Only")
      expect(page).to have_content("1")
    end

    within "#total-combined-medicaid-only" do
      expect(page).to have_content("Medicaid Only")
      expect(page).to have_content("1")
    end

    within "#total-combined-both" do
      expect(page).to have_content("SNAP and Medicaid")
      expect(page).to have_content("3")
    end

    expect(page).to have_content("People Served (20)")

    within "#total-combined-people" do
      expect(page).to have_content("Integrated Flow")
      expect(page).to have_content("15")
    end

    within "#total-snap-people" do
      expect(page).to have_content("Old SNAP Flow")
      expect(page).to have_content("3")
    end

    within "#total-medicaid-people" do
      expect(page).to have_content("Old Medicaid Flow")
      expect(page).to have_content("2")
    end

    expect(page).to have_content("Median Minutes to Complete (last 30 days)")

    within "#snap-only-time-to-complete" do
      expect(page).to have_content("SNAP Only")
    end

    within "#medicaid-only-time-to-complete" do
      expect(page).to have_content("Medicaid Only")
    end

    within "#combined-time-to-complete" do
      expect(page).to have_content("SNAP and Medicaid")
    end

    expect(page).to have_content("Median Minutes to Complete (all time)")

    within "#integrated-time-to-complete" do
      expect(page).to have_content("Integrated (all types)")
    end

    within "#snap-time-to-complete" do
      expect(page).to have_content("Old SNAP")
    end

    within "#medicaid-time-to-complete" do
      expect(page).to have_content("Old Medicaid")
    end
  end
end
