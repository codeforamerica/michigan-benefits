require "rails_helper"
require_relative "../support/pdf_helper"

RSpec.feature "Admin viewing medicaid applications dashboard", type: :feature do
  include PdfHelper

  before do
    user = create(:admin_user)
    login_as(user)
  end

  scenario "viewing details for a medicaid application" do
    application = create(
      :medicaid_application,
      email: "christa@example.com",
    )

    visit admin_root_path

    click_on "Medicaid Applications"

    click_on "christa@example.com"

    expect(page).to have_content("Medicaid Application ##{application.id}")
  end

  scenario "downloads the 1426 PDF application", javascript: true do
    application = create(
      :medicaid_application,
      members: [build(:member, first_name: "Christa", last_name: "Tester")],
    )

    visit admin_root_path

    click_on "Medicaid Applications"

    click_on "Download"

    expect(current_path).to eq(
      "/admin/medicaid_applications/#{application.id}/pdf",
    )
    temp_pdf = write_response_to_temp_file
    results = filled_in_values(file: temp_pdf)
    expect(results.values).to include("Christa Tester")
  end
end
