require "rails_helper"
RSpec.feature "Submit application with minimal information" do
  scenario "The stats are accurate", javascript: true do
    page.driver.browser.current_session.basic_authorize("admin", "password")
    5.times { create(:snap_application, signed_at: nil) }
    5.times { create(:snap_application, :emailed, signed_at: nil) }
    10.times { create(:snap_application, signed_at: 5.days.ago) }
    5.times { create(:snap_application, :faxed, signed_at: 5.days.ago) }
    visit admin_root_path
    expect(page).to have_content "25 Created"
    expect(page).to have_content "15 Signed"
    expect(page).to have_content "5 Emailed"
    expect(page).to have_content "5 Faxed"
  end
end
