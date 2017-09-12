require "rails_helper"
RSpec.feature "Submit application with minimal information" do
  scenario "The stats are accurate", javascript: true do
    page.driver.browser.current_session.basic_authorize("admin", "password")
    10.times { create(:snap_application, signed_at: nil) }
    1.times { create(:snap_application, :emailed, signed_at: nil) }
    9.times { create(:snap_application, signed_at: 5.days.ago) }
    1.times { create(:snap_application, :faxed, signed_at: 5.days.ago) }
    visit admin_root_path
    expect(page).to have_content "21 Created"
    expect(page).to have_content "10 Signed (47.6%)"
    expect(page).to have_content "1 Emailed (4.8%)"
    expect(page).to have_content "1 Faxed (4.8%)"
  end
end
