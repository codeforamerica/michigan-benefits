require "rails_helper"

RSpec.feature "Submit application with minimal information" do
  before do
    page.driver.browser.current_session.basic_authorize("admin", "password")
  end

  scenario "The stats are accurate", javascript: true do
    10.times { create(:snap_application, signed_at: nil) }
    1.times { create(:snap_application, :emailed_client, signed_at: nil) }
    1.times { create(:snap_application, :emailed_office, signed_at: nil) }
    9.times { create(:snap_application, signed_at: 5.days.ago) }
    1.times { create(:snap_application, :faxed, signed_at: 5.days.ago) }
    visit admin_root_path
    expect(page).to have_content "22 Created"
    expect(page).to have_content "10 Signed (45.5%)"
    expect(page).to have_content "1 Emailed Client (4.5%)"
    expect(page).to have_content "1 Emailed Office (4.5%)"
    expect(page).to have_content "1 Faxed (4.5%)"
  end

  scenario "resending a fax", javascript: true do
    application = create(:snap_application, :faxed, signed_at: 5.days.ago)
    visit admin_root_path

    click_link_or_button "Resend email to office"

    confirmation = "Resent email to #{application.receiving_office.email}" \
                   " for #{application.signature}!"

    expect(page).to have_content(confirmation)

    faxes = application.exports.for_destination(:fax)
    emails = application.exports.for_destination(:office_email)
    expect(faxes.count).to eq 1
    expect(emails.count).to eq 1
  end

  scenario "application detail timestamps are converted to Eastern timezone", javascript: true do
    date = DateTime.new(2017,4,5,6,30)

    application = create(:snap_application,
           created_at: date,
           updated_at: date + 1.hour,
           email: "person@example.com",
           signed_at: date + 2.hours)

    visit admin_root_path
    click_link_or_button "person@example.com"

    expect(page).to have_content("Snap Application ##{application.id}")

    expect(page).to have_content("Created At 04/05/2017 at 02:30AM EDT")
    expect(page).to have_content("Updated At 04/05/2017 at 03:30AM EDT")
    expect(page).to have_content("Signed At 04/05/2017 at 04:30AM EDT")
  end
end
