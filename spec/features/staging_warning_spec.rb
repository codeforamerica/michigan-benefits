require "rails_helper"

RSpec.feature "Warn users on staging or demo only", :a11y do
  before do
    allow(GateKeeper).to receive(:demo_environment?).and_return(true)
  end

  scenario "Renders the staging warning message" do
    visit root_path

    expect(page).to have_content("A user-centered integrated benefits application")
    proceed_with "Continue to demo"

    expect(page).to have_content("This site is for example purposes only.")

    within(".slab--hero") do
      proceed_with "Start your application"
    end

    on_page "Introduction" do
      expect(page).to have_content("Which programs do you want to apply for today?")
    end
  end
end
