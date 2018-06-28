require "rails_helper"

RSpec.feature "Admin viewing common applications dashboard", type: :feature do
  include PdfHelper

  before do
    user = create(:admin_user)
    login_as(user)
  end

  scenario "viewing details for a common application" do
    application = create(:common_application)

    visit admin_root_path

    click_on "Common Applications"

    click_on application.id

    expect(page).to have_content("Common Application ##{application.id}")
  end

  scenario "downloads the Integrated PDF application", javascript: true do
    application = create(:common_application)
    create(:household_member, first_name: "Christa", last_name: "Tester", common_application: application)

    visit admin_root_path

    click_on "Common Applications"

    click_on "Download"

    expect(current_path).to eq(
      "/admin/common_applications/#{application.id}/pdf",
    )
    temp_pdf = write_raw_pdf_to_temp_file(source: page.source)
    results = filled_in_values(temp_pdf)
    expect(results.values).to include("Christa Tester")
  end

  scenario "searching isn't broken", javascript: true do
    visit admin_common_applications_path(search: "asdf")

    expect(page).to have_content("Common Applications")
  end
end
