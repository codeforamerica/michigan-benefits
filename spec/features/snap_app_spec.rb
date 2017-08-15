require "rails_helper"

feature "SNAP application" do
  scenario "successfully submits application", :js do
    visit root_path
    click_on "Apply now"

    fill_in_name_and_birthday
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

    on_page "Introduction complete" do
      click_on "Continue"
    end

    select_radio(question: "What is your sex?", answer: "Female")
    select "Divorced", from: "What is your marital status?"
    fill_in "What is your social security number?", with: "123 12 1234"
    click_on "Continue"

    on_page "Your Household" do
      click_on "Add a member"
    end

    on_page "Your Household" do
      fill_in "What is their first name?", with: "Joey"
      fill_in "What is their last name?", with: "Tester"
      select_radio(question: "What is their sex?", answer: "Male")
      select "Child", from: "What is their relationship to you?"
      click_on "Continue"
    end

    on_page("Your Household") do
      click_on "Continue"
    end

    on_page("Your Household") do
      answer_household_more_info_questions
      click_on "Continue"
    end

    on_page "Money & Income" do
      choose "Yes"
      click_on "Continue"
    end

    on_page "Money & Income" do
      fill_in "step[income_change_explanation]", with: "EXPLAINING!!!"
      click_on "Continue"
    end

    on_page "Money & Income" do
      member_name = "Jessie (that’s you!)"

      within(".household-member-group[data-md5='#{data_md5(member_name)}']") do
        choose("Self Employed")
      end

      name_two = "Joey"

      within(".household-member-group[data-md5='#{data_md5(name_two)}']") do
        choose("Not Employed")
      end

      click_on "Continue"
    end

    consent_to_terms

    fill_in "Your signature", with: "Jessie Tester"
    click_on "Sign and submit"

    upload_documents
    click_on "Done uploading documents"

    fill_in "Your email address", with: "test@example.com"
    click_on "Submit"

    expect(page).to have_text(
      "You will receive an email with your filled out application attached in
        a few minutes.",
    )
  end

  scenario "does not fill in email address", :js do
    visit root_path
    click_on "Apply now"

    fill_in_name_and_birthday
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

    on_page "Introduction complete" do
      click_on "Continue"
    end

    select_radio(question: "What is your sex?", answer: "Female")
    select "Divorced", from: "What is your marital status?"
    click_on "Continue"

    on_page("Your Household") do
      click_on "Continue"
    end

    on_page("Your Household") do
      answer_household_more_info_questions
      click_on "Continue"
    end

    on_page "Money & Income" do
      choose "No"
      click_on "Continue"
    end

    on_page "Money & Income" do
      within(".household-member-group[data-member_name='Jessie Tester']") do
        choose("Self Employed")
      end

      click_on "Continue"
    end

    consent_to_terms

    fill_in "Your signature", with: "Jessie Tester"
    click_on "Sign and submit"

    upload_documents
    click_on "Done uploading documents"

    click_on "Skip this step"

    expect(page).to have_text(
      "Your application has been submitted.",
    )
  end

  scenario "home address not same as mailing address" do
    visit root_path
    click_on "Apply now"

    fill_in_name_and_birthday
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

    expect(current_path).to eq "/steps/introduction-complete"
  end

  scenario "goes back after skipping residential address step" do
    visit root_path
    click_on "Apply now"

    fill_in_name_and_birthday
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

    find(".step-header__back-link").click

    expect(current_path).to eq "/steps/mailing-address"
  end

  scenario "does not fill in all required fields" do
    visit root_path
    click_on "Apply now"

    fill_in_name_and_birthday
    click_on "Continue"

    fill_in "What is the best phone number to reach you?", with: "1234567890"
    click_on "Continue"

    expect(
      find_field("What is the best phone number to reach you?").value,
    ).to eq "1234567890"
  end

  scenario "saves user data across steps", :js do
    visit root_path
    click_on "Apply now"

    fill_in_name_and_birthday
    click_on "Continue"

    find(:css, ".step-header__back-link").click

    expect(find("#step_first_name").value).to eq "Jessie"
  end

  def fill_in_name_and_birthday
    fill_in "What is your first name?", with: "Jessie"
    fill_in "What is your last name?", with: "Tester"
    fill_in_birthday
  end

  def fill_in_birthday
    select "January", from: "step_birthday_2i"
    select "1", from: "step_birthday_3i"
    select "1969", from: "step_birthday_1i"
  end

  def subscribe_to_sms_updates
    select_radio(
      question: "May we send text messages to that phone number help you " + \
        "through the enrollment process?",
      answer: "Yes",
    )
  end

  def select_address_same_as_home_address
    select_radio(
      question: "Is this address the same as your home address?",
      answer: "Yes",
    )
  end

  def select_address_not_same_as_home_address
    select_radio(
      question: "Is this address the same as your home address?",
      answer: "No",
    )
  end

  def select_unstable_address
    check "Check this box if you do not have a stable address"
  end

  def answer_household_more_info_questions
    select_radio(
      question: "Is each person a US citizen/national?",
      answer: "Yes",
    )
    select_radio(
      question: "Does anyone have a disability?",
      answer: "No",
    )
    js_select_radio(
      question: "Is anyone pregnant or has been pregnant recently?",
      answer_id: "step_anyone_new_mom_false",
    )
    select_radio(
      question: "Is anyone enrolled in college or vocational school?",
      answer: "No",
    )
    select_radio(
      question: "Is anyone temporarily living outside the home?",
      answer: "No",
    )
  end

  def consent_to_terms
    choose("I agree")
    click_on "Continue"
  end

  def upload_documents
    click_on "Submit documents here"
    add_document_photo "https://example.com/images/drivers_license.jpg"
    add_document_photo "https://example.com/images/proof_of_income.jpg"
  end
end
