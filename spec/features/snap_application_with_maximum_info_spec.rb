require "rails_helper"

feature "SNAP application with maximum info" do
  include PdfHelper

  scenario "successfully submits application", :js do
    visit root_path
    within(".slab--hero") { proceed_with "Apply for FAP" }

    on_page "Introduction" do
      fill_in_name_and_birthday
      proceed_with "Continue"
    end

    on_page "Contact Information" do
      fill_in "What is the best phone number to reach you?", with: "2024561111"
      fill_in "What is your email address?", with: "test@example.com"
      proceed_with "Continue"
    end

    on_page "Your Location" do
      fill_in "Address", with: "123 Main St"
      fill_in "Address 2", with: "Apt B"
      fill_in "City", with: "Flint"
      fill_in "ZIP code", with: "12345"
      select_address_same_as_home_address
      proceed_with "Continue"
    end

    on_page "Introduction Complete" do
      proceed_with "Continue"
    end

    on_page "Introduction" do
      proceed_with "Continue"
    end

    on_page "Personal Details" do
      select_radio(question: "What is your sex?", answer: "Female")
      select "Divorced", from: "What is your marital status?"
      fill_in "What is your Social Security Number?",
              with: "123456789"
      proceed_with "Continue"
    end

    on_page "Case Details" do
      expect(page).to have_content(
        "Have you applied for benefits in Michigan before?",
      )
      proceed_with "No"
    end

    on_pages "Your Household" do
      click_on "Add a member"

      fill_in "What is their first name?", with: "Joey"
      fill_in "What is their last name?", with: "Tester"
      select_radio(question: "What is their sex?", answer: "Male")
      select "Child", from: "What is their relationship to you?"
      fill_in "What is their Social Security Number?",
              with: "111225566"
      proceed_with "Continue"

      proceed_with "Continue"

      answer_household_more_info_questions
      select_radio(
        question: "Is anyone enrolled in college or vocational school?",
        answer: "Yes",
      )
      proceed_with "Continue"

      within(find(:fieldset, text: "Who is enrolled in college?")) do
        check "Joey"
      end

      proceed_with "Continue"
    end

    on_page "Money & Income" do
      proceed_with "Continue"
    end

    on_page "Money & Income" do
      choose "Yes"
      proceed_with "Continue"
    end

    on_page "Money & Income" do
      fill_in "step[income_change_explanation]", with: "EXPLAINING!!!"
      proceed_with "Continue"
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
      proceed_with "Continue"
    end

    on_page "Money & Income" do
      fill_in "Employer name", with: "Company ABC Inc."
      fill_in "Usual hours per week", with: 25
      fill_in "Pay (before tax)", with: 100
      select "Weekly", from: "How often are you paid that amount?"

      fill_in "Type of work", with: "Chef"
      fill_in "Average monthly pay (before tax)", with: 300
      fill_in "Monthly business expenses", with: 100

      proceed_with "Continue"
    end

    on_page "Money & Income" do
      check "Pension"
      check "Social Security"

      proceed_with "Continue"
    end

    on_page "Money & Income" do
      fill_in "Pension", with: "100"
      fill_in "Social Security", with: "5"

      proceed_with "Continue"
    end

    on_page "Money & Income" do
      choose_yes("Does your household have any money or accounts?")
      choose_yes("Does your household own any property or real estate?")
      choose_yes("Does your household own any vehicles?")

      proceed_with "Continue"
    end

    on_page "Money & Income" do
      fill_in(
        "In total, how much money does your household have in cash and \
accounts?",
        with: 100,
      )
      check "Other"

      proceed_with "Continue"
    end

    on_page "Expenses" do
      proceed_with "Continue"
    end

    submit_housing_expenses
    submit_expense_sources(answer: "yes")
    submit_expenses

    on_page "Contact Preferences" do
      choose_yes(
        "Would you like text message reminders about key steps and documents" +
        " required to help you through the enrollment process?",
      )
      proceed_with "Continue"
    end

    on_page "Contact Preferences" do
      proceed_with "Continue"
    end

    on_page "Other Details" do
      choose "Yes"
      fill_in "If yes, what is their full legal name?", with: "Annie Dog"
      proceed_with "Continue"
    end

    on_page "Other Details" do
      fill_in "Anything else?", with: "This is helpful, thank you!"
      proceed_with "Continue"
    end

    on_page "Paperwork Guide" do
      expect(page).to have_content(
        "Do you have a picture ID for everyone in your household?",
      )
      select_radio(question: "Do you have a picture ID for everyone in your household?",
                   answer: "I have this today")

      proceed_with "Continue"
    end

    on_page "Paperwork Guide" do
      expect(page).to have_content(
        "Do you have proof of all pay you received in the last 30 days?",
      )
      select_radio(question: "Do you have proof of all pay you received in the last 30 days?",
                   answer: "I need help or can't get this")

      proceed_with "Continue"
    end

    on_page "Paperwork Guide" do
      expect(page).to have_content(
        "Do you have proof of all pay Joey Tester received in the last 30 days?",
      )
      select_radio(question: "Do you have proof of all pay Joey Tester received in the last 30 days?",
                   answer: "I can get this soon")

      proceed_with "Continue"
    end

    on_page "Paperwork" do
      expect(page).to have_content(
        "Review your paperwork",
      )
      expect(page).to have_content(
        "Ask a lobby navigator for help with:",
      )
      expect(page).to have_content(
        "Proof of all pay you received in the last 30 days.",
      )
      expect(page).to have_content(
        "Make a plan to get:",
      )
      expect(page).to have_content(
        "Proof of all pay Joey Tester received in the last 30 days.",
      )
      expect(page).to have_content(
        "Upload now:",
      )
      expect(page).to have_content(
        "A picture ID for everyone in your household.",
      )
      proceed_with "Upload paperwork now"
    end

    on_page "Paperwork" do
      expect(page).to have_content(
        "Upload paperwork",
      )
      upload_paperwork
      proceed_with "Finish"
    end

    consent_to_terms

    on_page "Sign and Submit" do
      fill_in "Sign by typing your full legal name", with: "Jessie Tester"
      proceed_with "Sign and submit"
    end

    on_page "Application Submitted" do
      fill_in "Your email address", with: "test@example.com"
      proceed_with "Submit"
    end

    expect(page).to have_text(
      "Your application has been sent to your email inbox",
    )

    emails = ActionMailer::Base.deliveries

    raw_application_pdf = emails.first.attachments.first.body.raw_source
    temp_file = write_raw_pdf_to_temp_file(source: raw_application_pdf)
    pdf_values = filled_in_values(temp_file.path)

    expect(pdf_values["primary_member_full_name"]).to include("Jessie Tester")
  end

  def upload_paperwork
    add_document_photo "https://example.com/images/image_1.jpg"
    add_document_photo "https://example.com/images/image_2.jpg"
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

      proceed_with "Continue"
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

      proceed_with "Continue"
    end
  end
end
