require "rails_helper"

RSpec.feature "Navigate back in flow" do
  scenario "saves user data across steps" do
    visit root_path
    within(".slab--hero") { click_on "Apply now" }

    fill_in_name_and_birthday
    click_on "Continue"

    find(:css, ".step-header__back-link").click

    expect(find("#step_first_name").value).to eq "Jessie"
  end
end
