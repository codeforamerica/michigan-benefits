require "rails_helper"

RSpec.feature "Warn users on staging only" do
  scenario "Renders the staging warning message" do
    allow(GateKeeper).to receive(:demo_environment?).and_return(true)

    visit root_path
    expect(page).to have_content("This is an example website")

    within(".slab--hero") { click_on "Start your application" }
    expect(page).to have_content("This is an example website")

    visit "/clio"
    expect(page).to have_content("This is an example website")
  end

  scenario "Does not render warning message when not on staging" do
    visit root_path
    expect(page).to_not have_content("This is an example website")
  end
end
