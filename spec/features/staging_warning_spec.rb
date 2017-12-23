require "rails_helper"

RSpec.feature "Warn users on staging only" do
  scenario "Renders the staging warning message", :js do
    # Stub out Rails.env to "staging"
    allow(Rails).to receive(:env).and_return(
      ActiveSupport::StringInquirer.new("staging"),
    )

    visit root_path
    expect(page).to have_content("This is an example website")

    within(".slab--hero") { proceed_with "Apply now" }
    expect(page).to have_content("This is an example website")

    visit "/clio"
    expect(page).to have_content("This is an example website")
  end

  scenario "Does not render warning message when not on staging", :js do
    visit root_path
    expect(page).to_not have_content("This is an example website")
  end
end
