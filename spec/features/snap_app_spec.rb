require "rails_helper"

feature "SNAP application" do
  scenario "successfully submits application" do
    visit root_path
    click_on "Apply now"

    fill_in "What is your full name?", with: "Jessie Tester"
    select "January", from: "step_birthday_2i"
    select "1", from: "step_birthday_3i"
    select "1969", from: "step_birthday_1i"

    click_on "Continue"

    fill_in "Address", with: "123 Main St"
    fill_in "City", with: "Flint"
    fill_in "County", with: "Genesee"
    fill_in "State", with: "MI"
    fill_in "ZIP code", with: "12345"
    click_on "Continue"

    fill_in "Your signature", with: "Jessie Tester"
    click_on "Sign and submit"

    fill_in "Your email address", with: "test@example.com"
    click_on "Submit"

    expect(page).to have_text(
      "You will receive an email with your filled out application attached in a few minutes.",
    )
  end

  scenario "does not fill in email address" do
    visit root_path
    click_on "Apply now"

    fill_in "What is your full name?", with: "Jessie Tester"
    select "January", from: "step_birthday_2i"
    select "1", from: "step_birthday_3i"
    select "1969", from: "step_birthday_1i"

    click_on "Continue"

    fill_in "Address", with: "123 Main St"
    fill_in "City", with: "Flint"
    fill_in "County", with: "Genesee"
    fill_in "State", with: "MI"
    fill_in "ZIP code", with: "12345"
    click_on "Continue"

    fill_in "Your signature", with: "Jessie Tester"
    click_on "Sign and submit"

    click_on "Skip this step"

    expect(page).to have_text(
      "Your application has been submitted.",
    )
  end

  scenario "does not fill in all required fields" do
    visit root_path
    click_on "Apply now"

    fill_in "What is your full name?", with: "Jessie Tester"
    click_on "Continue"
    fill_in "City", with: "Flint"
    click_on "Continue"

    expect(find_field("City").value).to eq "Flint"
  end
end
