require "rails_helper"

RSpec.feature "Homepage is closed", :a11y do
  before do
    allow(GateKeeper).to receive(:feature_enabled?).and_return(false)
    allow(GateKeeper).to receive(:feature_enabled?).with("FLOW_CLOSED").and_return(true)
    Rails.application.reload_routes!
  end

  scenario "Show the we're closed page" do
    visit root_path

    expect(page).to have_content("Michigan Benefits is closed")
  end
end
