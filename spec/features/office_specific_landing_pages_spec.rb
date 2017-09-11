require "rails_helper"

RSpec.feature "Office-specific landing pages" do
  scenario "clio road" do
    visit "/clio"
    click_on "Apply now from MDHHS at Clio Rd."

    expect(current_path).to eq "/steps/introduce-yourself"
    expect(find("#step_office_location", visible: false).value).to eq("clio")
  end

  scenario "union street" do
    visit "/union"
    click_on "Apply now from MDHHS at Union St."

    expect(current_path).to eq "/steps/introduce-yourself"
    expect(find("#step_office_location", visible: false).value).to eq("union")
  end

  scenario "regular home page" do
    visit root_path
    click_on "Apply now"

    expect(current_path).to eq "/steps/introduce-yourself"
    expect(find("#step_office_location", visible: false).value).to eq(nil)
  end
end
