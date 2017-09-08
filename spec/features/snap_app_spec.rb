require "rails_helper"

feature "SNAP application" do
  scenario "successfully submits application", :js do
    visit root_path
    click_on "Apply now"

    fill_in_name_and_birthday
    click_on "Continue"

    fill_in "What is the best phone number to reach you?", with: "2223334444"
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

    on_page "Introduction" do
      click_on "Continue"
    end

    select_radio(question: "What is your sex?", answer: "Female")
    select "Divorced", from: "What is your marital status?"
    fill_in "What is your social security number?", with: "123121234"
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
      select_radio(
        question: "Is anyone enrolled in college or vocational school?",
        answer: "Yes",
      )
      click_on "Continue"
    end

    on_page("Your Household") do
      within(find(:fieldset, text: "Who is enrolled in college?")) do
        check "Joey"
      end

      click_on "Continue"
    end

    on_page "Money & Income" do
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
      select_employment(
        full_name: "Jessie Tester",
        employment_status: "Self Employed",
      )
      select_employment(
        full_name: "Joey Tester",
        employment_status: "Employed",
      )
      click_on "Continue"
    end

    on_page "Money & Income" do
      fill_in "Employer name", with: "Company ABC Inc."
      fill_in "Usual hours per week", with: 25
      fill_in "Pay (before tax)", with: 100
      select "Daily", from: "How often are you paid that amount?"

      fill_in "Type of work", with: "Chef"
      fill_in "Monthly pay (before tax)", with: 300
      fill_in "Monthly expenses", with: 100

      click_on "Continue"
    end

    on_page "Money & Income" do
      check "Pension"
      check "Social Security"

      click_on "Continue"
    end

    on_page "Money & Income" do
      fill_in "Pension", with: "100"
      fill_in "Social Security", with: "5"

      click_on "Continue"
    end

    on_page "Money & Income" do
      choose_yes("Does your household have any money or accounts?")
      choose_yes("Does your household own any property or real estate?")
      choose_yes("Does your household own any vehicles?")

      click_on "Continue"
    end

    on_page "Money & Income" do
      fill_in(
        "In total, how much money does your household have in cash and \
accounts?",
        with: 100,
      )
      check "Other"

      click_on "Continue"
    end

    on_page "Expenses" do
      click_on "Continue"
    end

    submit_housing_expenses
    submit_expense_sources(answer: "yes")
    submit_expenses

    on_page "Preferences" do
      check "Text message me"
      check "Email me"
      click_on "Continue"
    end

    on_page "General" do
      fill_in "Anything else?", with: "This is helpful, thank you!"
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

    fill_in "What is the best phone number to reach you?", with: "2222222222"
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

    on_page "Introduction" do
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
      click_on "Continue"
    end

    on_page "Money & Income" do
      choose "No"
      click_on "Continue"
    end

    on_page "Money & Income" do
      select_employment(
        full_name: "Jessie Tester",
        employment_status: "Not Employed",
      )

      click_on "Continue"
    end

    on_page "Money & Income" do
      click_on "Continue"
    end

    on_page "Money & Income" do
      choose_no("Does your household have any money or accounts?")
      choose_no("Does your household own any property or real estate?")
      choose_no("Does your household own any vehicles?")

      click_on "Continue"
    end

    on_page "Expenses" do
      click_on "Continue"
    end

    on_page "Expenses" do
      click_on "Continue"
    end

    submit_expense_sources(answer: "no")

    on_page "Preferences" do
      click_on "Continue"
    end

    on_page "General" do
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

    fill_in "What is the best phone number to reach you?", with: "2223334444"
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

    fill_in "What is the best phone number to reach you?", with: "2223334444"
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

    fill_in "What is the best phone number to reach you?", with: "2223334444"
    click_on "Continue"

    fill_in "Address", with: "123 Main St."
    click_on "Continue"

    expect(
      find_field("Address").value,
    ).to eq "123 Main St."
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

  def consent_to_terms
    choose "I agree"
    click_on "Continue"
  end

  def upload_documents
    click_on "Submit documents here"
    add_document_photo "https://example.com/images/drivers_license.jpg"
    add_document_photo "https://example.com/images/proof_of_income.jpg"
  end

  def select_employment(full_name:, employment_status:)
    within(".household-member-group[data-member-name='#{full_name}']") do
      choose(employment_status)
    end
  end

  def choose_yes(text)
    within(find(:fieldset, text: text)) do
      choose "Yes"
    end
  end

  def choose_no(text)
    within(find(:fieldset, text: text)) do
      choose "No"
    end
  end

  def submit_housing_expenses
    on_page "Expenses" do
      fill_in "step[rent_expense]", with: "600"
      fill_in "step[property_tax_expense]", with: "100"
      fill_in "step[insurance_expense]", with: "100"

      check "Heat"
      check "Cooling"

      click_on "Continue"
    end
  end

  def submit_expense_sources(answer:)
    on_page "Expenses" do
      send(
        "choose_#{answer}",
        "Does your household have dependent care expenses?",
      )
      send(
        "choose_#{answer}",
        "Does your household have medical expenses?",
      )
      send(
        "choose_#{answer}",
        "Does your household have court-ordered expenses?",
      )
      click_on "Continue"
    end
  end

  def submit_expenses
    on_page "Expenses" do
      fill_in "step[monthly_care_expenses]", with: "200"
      check "Childcare"

      fill_in "step[monthly_medical_expenses]", with: "200"
      check "Co-pays"

      fill_in "step[monthly_court_ordered_expenses]", with: "10"
      check "Alimony"

      click_on "Continue"
    end
  end
end
