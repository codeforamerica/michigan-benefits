require "rails_helper"

RSpec.feature "MI Bridges Driving" do
  # to run this in a non-headless way, remove the `:js` flag below
  scenario "successfully drives a SNAP Application", :js, :driving do
    WebMock.disable!

    address = create(:mailing_address)
    member = create(:member, sex: "male")
    snap_application = create(
      :snap_application,
      members: [member],
      mailing_address_same_as_residential_address: true,
      addresses: [address],
    )

    MiBridges::Driver.new(snap_application: snap_application).run
    expect(page).to have_content("Before You Submit the Application")

    WebMock.enable!
  end
end
