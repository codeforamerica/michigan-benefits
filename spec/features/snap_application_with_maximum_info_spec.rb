require "rails_helper"

feature "SNAP application with maximum info" do
  scenario "successfully submits application", :js do
    visit root_path
    within(".slab--hero") { click_on "Apply now" }

    on_page "Introduction" do
      fill_in_name_and_birthday
      click_on "Continue"
    end

    on_page "Contact Information" do
      fill_in "What is the best phone number to reach you?", with: "2223334444"
      fill_in "What is your email address?", with: "test@example.com"
      click_on "Continue"
    end

    on_page "Your Location" do
      fill_in "Address", with: "123 Main St"
      fill_in "Address 2", with: "Apt B"
      fill_in "City", with: "Flint"
      fill_in "ZIP code", with: "12345"
      select_address_same_as_home_address
      click_on "Continue"
    end

    on_page "Introduction Complete" do
      click_on "Continue"
    end

    on_page "Introduction" do
      click_on "Continue"
    end

    on_page "Personal Details" do
      select_radio(question: "What is your sex?", answer: "Female")
      select "Divorced", from: "What is your marital status?"
      fill_in "What is your Social Security Number?",
              with: "123456789"
      click_on "Continue"
    end

    on_page "Your Household" do
      click_on "Add a member"
    end

    on_page "Your Household" do
      fill_in "What is their first name?", with: "Joey"
      fill_in "What is their last name?", with: "Tester"
      select_radio(question: "What is their sex?", answer: "Male")
      select "Child", from: "What is their relationship to you?"
      fill_in "What is their Social Security Number?",
              with: "111225566"
      click_on "Continue"
    end

    on_page "Your Household" do
      click_on "Continue"
    end

    on_page "Your Household" do
      answer_household_more_info_questions
      select_radio(
        question: "Is anyone enrolled in college or vocational school?",
        answer: "Yes",
      )
      click_on "Continue"
    end

    on_page "Your Household" do
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
        display_name: "Jessie Tester",
        employment_status: "Self Employed",
      )
      select_employment(
        display_name: "Joey Tester",
        employment_status: "Employed",
      )
      click_on "Continue"
    end

    on_page "Money & Income" do
      fill_in "Employer name", with: "Company ABC Inc."
      fill_in "Usual hours per week", with: 25
      fill_in "Pay (before tax)", with: 100
      select "Weekly", from: "How often are you paid that amount?"

      fill_in "Type of work", with: "Chef"
      fill_in "Average monthly pay (before tax)", with: 300
      fill_in "Monthly business expenses", with: 100

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

    on_page "Contact Preferences" do
      choose_yes(
        "Would you like text message reminders about key steps and documents" +
        " required to help you through the enrollment process?",
      )
      click_on "Continue"
    end

    on_page "Contact Preferences" do
      click_on "Continue"
    end

    on_page "Other Details" do
      choose "Yes"
      fill_in "If yes, what is their full legal name?", with: "Annie Dog"
      click_on "Continue"
    end

    on_page "Other Details" do
      fill_in "Anything else?", with: "This is helpful, thank you!"
      click_on "Continue"
    end

    consent_to_terms

    on_page "Sign and Submit" do
      fill_in "Sign by typing your full legal name", with: "Jessie Tester"
      click_on "Sign and submit"
    end

    on_page "Documents" do
      upload_documents
      click_on "Done uploading documents"
    end

    on_page "Application Submitted" do
      fill_in "Your email address", with: "test@example.com"
      click_on "Submit"
    end

    expect(page).to have_text(
      "Your application has been sent to your email inbox",
    )
  end

  scenario "saves user data across steps" do
    visit root_path
    within(".slab--hero") { click_on "Apply now" }

    fill_in_name_and_birthday
    click_on "Continue"

    find(:css, ".step-header__back-link").click

    expect(find("#step_first_name").value).to eq "Jessie"
  end

  def upload_documents
    click_on "Submit documents now"
    add_document_photo "https://example.com/images/drivers_license.jpg"
    add_document_photo "https://example.com/images/proof_of_income.jpg"
  end

  def add_document_photo(url)
    input = %(<input type="hidden" name="step[documents][]" value="#{url}">)
    page.execute_script(
      <<~JAVASCRIPT
        document.querySelector('[data-uploadables-form]').
          insertAdjacentHTML('beforeend', '#{input}')
      JAVASCRIPT
    )
  end

  def submit_housing_expenses
    on_page "Expenses" do
      fill_in "step[rent_expense]", with: "600"
      fill_in "step[property_tax_expense]", with: "100"
      fill_in "step[insurance_expense]", with: "100"

      check "Heat"
      check "Air Conditioning"

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
