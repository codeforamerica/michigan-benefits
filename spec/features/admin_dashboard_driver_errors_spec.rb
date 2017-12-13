require "rails_helper"

RSpec.feature "Admin viewing driver errors dashboard", type: :feature do
  include PdfHelper

  before do
    user = create(:admin_user)
    login_as(user)
  end

  scenario "show", javascript: true do
    driver_error = create(
      :driver_error,
      error_class: "FakeError",
      backtrace: "the error happened on a line right here, see?!",
    )

    driver_application = driver_error.driver_application
    driver_application.update(
      page_history: ["FirstPage", "SecondPage"],
    )

    visit admin_root_path

    click_on "Driver Errors"

    expect(page).to have_link(
      driver_error.driver_application.snap_application_id,
    )

    click_on "FakeError"

    expect(page).to have_content(
      "the error happened on a line right here, see?!",
    )

    expect(page).to have_link(
      driver_error.driver_application.snap_application_id,
    )

    expect(page).to have_content("FirstPage")
    expect(page).to have_content("SecondPage")
  end
end
