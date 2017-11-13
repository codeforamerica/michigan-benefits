require "rails_helper"

RSpec.feature "Submit application with minimal information" do
  before do
    user = create(:admin_user)
    login_as(user)
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

  scenario "dashboard timestamps are converted to EST", javascript: true do
    date = DateTime.new(2017, 4, 5, 1, 30)

    application = create(:snap_application,
           created_at: date,
           updated_at: date + 1.hour,
           email: "person@example.com",
           signed_at: date + 2.hours)

    visit admin_root_path

    expect(page).to have_content("2017-04-04") # Signed at date

    click_link_or_button "person@example.com"

    expect(page).to have_content("Snap Application ##{application.id}")

    expect(page).to have_content("Created At 04/04/2017 at 09:30PM EDT")
    expect(page).to have_content("Updated At 04/04/2017 at 10:30PM EDT")
    expect(page).to have_content("Signed At 04/04/2017 at 11:30PM EDT")
  end

  scenario "logging out", javascript: true do
    visit admin_root_path

    click_link "Sign Out"

    visit admin_root_path

    expect(page).to have_content("Log in")
  end
end
