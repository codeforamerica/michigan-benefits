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
end
