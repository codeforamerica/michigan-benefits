require "rails_helper"

RSpec.feature "Office-specific landing pages" do
  scenario "clio road" do
    visit "/clio"
    click_on "Apply at this office"

    expect(current_path).to eq "/steps/introduce-yourself"
    expect(find("#step_office_location", visible: false).value).to eq("clio")
  end

  scenario "union street" do
    visit "/union"
    click_on "Apply at this office"

    expect(current_path).to eq "/steps/introduce-yourself"
    expect(find("#step_office_location", visible: false).value).to eq("union")
  end

  scenario "regular home page" do
    visit root_path
    within(".slab--hero") { click_on "Apply now" }

    expect(current_path).to eq "/steps/introduce-yourself"
    expect(find("#step_office_location", visible: false).value).to eq(nil)
  end
end
