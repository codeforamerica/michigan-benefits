require "rails_helper"

feature "SNAP application" do
  scenario "successfully submits application", :js do
    visit root_path
    click_on "Apply now"

    fill_in "What is your full name?", with: "Jessie Tester"
    select "January", from: "step_birthday_2i"
    select "1", from: "step_birthday_3i"
    select "1969", from: "step_birthday_1i"
    click_on "Continue"

    fill_in "What is the best phone number to reach you?", with: "12345678990"
    subscribe_to_sms_updates
    fill_in "What is your email address?", with: "test@example.com"
    click_on "Continue"

    fill_in "Address", with: "123 Main St"
    fill_in "City", with: "Flint"
    fill_in "ZIP code", with: "12345"
    select_address_same_as_home_address
    click_on "Continue"

    consent_to_terms

    fill_in "Your signature", with: "Jessie Tester"
    click_on "Sign and submit"

    add_document_photo "https://example.com/images/drivers_license.jpg"
    add_document_photo "https://example.com/images/proof_of_income.jpg"
    click_on "Continue"

    fill_in "Your email address", with: "test@example.com"
    click_on "Submit"

    expect(page).to have_text(
      "You will receive an email with your filled out application attached in a few minutes.",
    )
  end

  scenario "does not fill in email address", :js do
    visit root_path
    click_on "Apply now"

    fill_in "What is your full name?", with: "Jessie Tester"
    select "January", from: "step_birthday_2i"
    select "1", from: "step_birthday_3i"
    select "1969", from: "step_birthday_1i"
    click_on "Continue"

    fill_in "What is the best phone number to reach you?", with: "12345678990"
    subscribe_to_sms_updates
    fill_in "What is your email address?", with: "test@example.com"
    click_on "Continue"

    fill_in "Address", with: "123 Main St"
    fill_in "City", with: "Flint"
    fill_in "ZIP code", with: "12345"
    select_address_same_as_home_address
    click_on "Continue"

    consent_to_terms

    fill_in "Your signature", with: "Jessie Tester"
    click_on "Sign and submit"

    add_document_photo "https://example.com/images/drivers_license.jpg"
    add_document_photo "https://example.com/images/proof_of_income.jpg"
    click_on "Continue"

    click_on "Skip this step"

    expect(page).to have_text(
      "Your application has been submitted.",
    )
  end

  scenario "home address not same as mailing address" do
    visit root_path
    click_on "Apply now"

    fill_in "What is your full name?", with: "Jessie Tester"
    select "January", from: "step_birthday_2i"
    select "1", from: "step_birthday_3i"
    select "1969", from: "step_birthday_1i"
    click_on "Continue"

    fill_in "What is the best phone number to reach you?", with: "12345678990"
    subscribe_to_sms_updates
    fill_in "What is your email address?", with: "test@example.com"
    click_on "Continue"

    fill_in "Address", with: "123 Main St"
    fill_in "City", with: "Flint"
    fill_in "ZIP code", with: "12345"
    select_address_not_same_as_home_address
    click_on "Continue"

    expect(current_path).to eq "/steps/residential-address"
    fill_in "Address", with: "456 Hello St"
    fill_in "City", with: "Flint"
    fill_in "ZIP code", with: "12345"
    select_unstable_address
    click_on "Continue"

    expect(current_path).to eq "/steps/legal-agreement"
  end

  scenario "does not fill in all required fields" do
    visit root_path
    click_on "Apply now"

    fill_in "What is your full name?", with: "Jessie Tester"
    click_on "Continue"

    fill_in "What is the best phone number to reach you?", with: "1234567890"
    click_on "Continue"

    expect(find_field("What is the best phone number to reach you?").value).to eq "1234567890"
  end

  scenario "saves user data across steps", :js do
    visit root_path
    click_on "Apply now"

    fill_in "What is your full name?", with: "Jessie Tester"
    select "January", from: "step_birthday_2i"
    select "1", from: "step_birthday_3i"
    select "1969", from: "step_birthday_1i"
    click_on "Continue"

    find(:css, ".step-header__back-link").click

    expect(find("#step_name").value).to eq "Jessie Tester"
  end

  def subscribe_to_sms_updates
    choose "Yes"
  end

  def select_address_same_as_home_address
    choose "Yes"
  end

  def select_address_not_same_as_home_address
    choose "No"
  end

  def select_unstable_address
    check "Check this box if you do not have a stable address"
  end

  def consent_to_terms
    choose "I agree"
    click_on "Continue"
  end
end
