require "rails_helper"

RSpec.feature "Admins can view exports" do
  before do
    user = create(:admin_user)
    login_as(user)
  end

  scenario "Exports are listed" do
    medicaid_application = build(:medicaid_application)
    snap_application = build(:snap_application)
    medicaid_export = create(:export, benefit_application: medicaid_application)
    snap_export = create(:export, benefit_application: snap_application)

    visit admin_exports_path

    within "[data-url='#{admin_export_path(medicaid_export)}']" do
      expect(page).to have_content(
        "Medicaid Application ##{medicaid_application.id}",
      )
    end

    within "[data-url='#{admin_export_path(snap_export)}']" do
      expect(page).to have_content(
        "Snap Application ##{snap_application.id}",
      )
    end
  end
end
