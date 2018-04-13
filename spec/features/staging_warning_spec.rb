require "rails_helper"

RSpec.feature "Warn users on staging only" do
  xscenario "Renders the staging warning message", :js do
    allow(GateKeeper).to receive(:demo_environment?).and_return(true)

    visit root_path
    expect(page).to have_content("This is an example website")

    within(".slab--hero") { proceed_with "Apply for FAP" }
    expect(page).to have_content("This is an example website")

    visit "/clio"
    expect(page).to have_content("This is an example website")
  end

  scenario "Does not render warning message when not on staging", :js do
    visit root_path
    expect(page).to_not have_content("This is an example website")
  end
end
