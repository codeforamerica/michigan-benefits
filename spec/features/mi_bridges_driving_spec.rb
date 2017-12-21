require "rails_helper"

RSpec.feature "MI Bridges Driving" do
  # you can run this test via the rake task `rake mi_bridges:run`
  # to run this in a non-headless way, remove the `:js` flag below
  scenario "successfully drives, then re-drives a SNAP App", :js, :driving do
    WebMock.disable!

    address = build(:mailing_address, county: "Genesee")
    member = build(:member, marital_status: "Married", sex: "male")
    second_member = build(:member, first_name: "Jojo", sex: "female")
    snap_application = create(
      :snap_application,
      members: [member, second_member],
      mailing_address_same_as_residential_address: true,
      addresses: [address],
      dependent_care: true,
    )

    MiBridges::Driver.new(snap_application: snap_application).run
    expect(snap_application.driver_applications.count).to eq 1
    expect(page).to have_content("Important Information and Signature")

    browser = Capybara.current_session.driver.browser
    browser.manage.delete_all_cookies

    MiBridges::Driver.new(snap_application: snap_application).re_run
    expect(snap_application.driver_applications.count).to eq 1
    expect(page).to have_content("Important Information and Signature")

    WebMock.enable!
  end
end
