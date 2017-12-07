require "rails_helper"

RSpec.feature "MI Bridges Driving" do
  # to run this in a non-headless way, remove the `:js` flag below
  scenario "successfully drives, then re-drives a SNAP App", :driving do
    WebMock.disable!

    address = build(:mailing_address, county: "Genesee")
    member = build(:member, sex: "male")
    snap_application = create(
      :snap_application,
      members: [member],
      mailing_address_same_as_residential_address: true,
      addresses: [address],
    )

    MiBridges::Driver.new(snap_application: snap_application).run
    expect(snap_application.driver_applications.count).to eq 1
    expect(page).to have_content("Before You Submit the Application")

    browser = Capybara.current_session.driver.browser
    browser.manage.delete_all_cookies

    MiBridges::Driver.new(snap_application: snap_application).re_run
    expect(snap_application.driver_applications.count).to eq 1
    expect(page).to have_content("Before You Submit the Application")

    WebMock.enable!
  end
end
