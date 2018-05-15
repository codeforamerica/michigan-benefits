require "rails_helper"

RSpec.feature "Integrated application" do
  include PdfHelper

  CIRCLED = Integrated::PdfAttributes::CIRCLED
  UNDERLINED = Integrated::PdfAttributes::UNDERLINED

  scenario "with multiple members", :js do
    visit combined_home_path

    within(".slab--hero") do
      proceed_with "Apply for FAP and Medicaid"
    end

    on_page "Introduction" do
      expect(page).to have_content("Do you currently reside in Michigan?")

      proceed_with "Yes"
    end

    on_page "Introduction" do
      expect(page).to have_content("To start, please introduce yourself")

      fill_in "What's your first name?", with: "Jessie"
      fill_in "What's your last name?", with: "Tester"

      fill_in "Month", with: "1"
      fill_in "Day", with: "1"
      fill_in "Year", with: "1969"

      select_radio(question: "What's your sex?", answer: "Female")

      select_radio(
        question: "Have you received assistance in Michigan in the past (or currently)?",
        answer: "Yes",
      )

      proceed_with "Continue"
    end

    on_page "Introduction" do
      expect(page).to have_content("What's your current living situation?")

      select_radio(
        question: "What's your current living situation?",
        answer: "Stable address",
      )

      proceed_with "Continue"
    end

    on_page "Introduction" do
      expect(page).to have_content("What's your home address?")

      fill_in "Street address", with: "123 Main St"
      fill_in "Street address 2", with: "Apt B"
      fill_in "City", with: "Flint"
      fill_in "ZIP code", with: "48550"

      select_radio(
        question: "Is this also your mailing address?",
        answer: "No",
      )

      proceed_with "Continue"
    end

    on_page "Introduction" do
      expect(page).to have_content("Tell us where to send you postal mail.")

      fill_in "Street address", with: "PO Box 123"
      fill_in "City", with: "Flint"
      fill_in "ZIP code", with: "48550"

      proceed_with "Continue"
    end

    on_page "Your Household" do
      expect(page).to have_content(
        "Who do you currently live with?",
      )
      expect(page).to have_content("Jessie Tester (that’s you!)")

      click_on "Add a member"
    end

    members = [
      {
        first_name: "Jonny",
        last_name: "Tester",
        dob: ["1", "1", "1969"],
        sex: "Female",
        relation: "Spouse",
      },
      {
        first_name: "Jackie",
        last_name: "Tester",
        dob: ["1", "1", "1970"],
        sex: "Male",
        relation: "Sibling",
      },
      {
        first_name: "Joe",
        last_name: "Schmoe",
        dob: ["1", "1", "1998"],
        sex: "Female",
        relation: "Parent",
      },
      {
        first_name: "Apples",
        last_name: "McMackintosh",
        dob: ["1", "1", "1998"],
        sex: "Male",
        relation: "Other",
      },
      {
        first_name: "Pupper",
        last_name: "McDog",
        dob: ["12", "30", "2016"],
        sex: "Male",
        relation: "Child",
      },
    ]

    members.each do |member|
      on_page "Your Household" do
        expect(page).to have_content("Add a person you want to apply with")

        fill_in "What's their first name?", with: member[:first_name]
        fill_in "What's their last name?", with: member[:last_name]

        fill_in "Month", with: member[:dob][0]
        fill_in "Day", with: member[:dob][1]
        fill_in "Year", with: member[:dob][2]

        select_radio(question: "What's their sex?", answer: member[:sex])

        select member[:relation], from: "What is their relationship to you?"

        proceed_with "Continue"
      end

      on_page "Your Household" do
        expect(page).to have_content(
          "Who do you currently live with?",
        )

        expect(page).to have_content("#{member[:first_name]} #{member[:last_name]}")

        member == members.last ? click_on("Continue") : click_on("Add a member")
      end
    end

    on_page "Your Household" do
      expect(page).to have_content(
        "Who do you want to include on your Food Assistance application?",
      )

      # Jessie Tester checked by default
      check "Jonny Tester"
      check "Jackie Tester"
      check "Joe Schmoe"
      check "Pupper McDog"

      proceed_with "Continue"
    end

    on_page "Your Household" do
      expect(page).to have_content(
        "Do all of you share meals and food costs?",
      )

      proceed_with "No"
    end

    on_page "Your Household" do
      expect(page).to have_content(
        "Who buys and makes food separately?",
      )

      check "Jonny Tester"

      proceed_with "Continue"
    end

    on_page "Review" do
      expect(page).to have_content(
        "Here's who's applying for Food Assistance with you:",
      )

      within "#applying-with-you" do
        expect(page).to have_content("Jessie Tester (that's you!)")
        expect(page).to have_content("Jackie Tester")
        expect(page).to have_content("Joe Schmoe")
        expect(page).to have_content("Pupper McDog")
      end

      within "#not-applying-with-you" do
        expect(page).to have_content("Jonny Tester")
      end

      proceed_with "Continue"
    end

    on_page "Healthcare" do
      expect(page).to have_content(
        "Which people also need Healthcare Coverage?",
      )

      click_on "Add a person"
    end

    kitty = {
      first_name: "Kitty",
      last_name: "DeRat",
      relationship: "Roommate",
    }
    on_page "Healthcare" do
      expect(page).to have_content("Add a person.")

      fill_in "What's their first name?", with: kitty[:first_name]
      fill_in "What's their last name?", with: kitty[:last_name]
      select kitty[:relationship], from: "What is their relationship to you?"

      proceed_with "Continue"
    end
    members << kitty

    on_page "Healthcare" do
      expect(page).to have_content(
        "Which people also need Healthcare Coverage?",
      )

      # Jessie Tester checked by default
      check "Joe Schmoe"
      check "Pupper McDog"
      # Kitty DeRat checked by default

      proceed_with "Continue"
    end

    on_page "Healthcare" do
      expect(page).to have_content("Will you file taxes next year?")

      proceed_with "Yes"
    end

    on_page "Healthcare" do
      expect(page).to have_content("Is there anyone else who can be included on your tax return?")

      proceed_with "Yes"
    end

    on_page "Healthcare" do
      expect(page).to have_content("How will you include others on your taxes?")

      select_radio(question: "Jonny Tester", answer: "Married filing jointly")
      select_radio(question: "Jackie Tester", answer: "Dependent")
      select_radio(question: "Joe Schmoe", answer: "Not included")
      select_radio(question: "Apples McMackintosh", answer: "Not included")
      select_radio(question: "Pupper McDog", answer: "Dependent")
      select_radio(question: "Kitty DeRat", answer: "Not included")

      proceed_with "Continue"
    end

    on_page "Healthcare" do
      expect(page).to have_content("Is there anyone else who can be included on your tax return?")

      within "#tax-included" do
        expect(page).to have_content("Jessie Tester (that's you!)")
        expect(page).to have_content("Jonny Tester")
        expect(page).to have_content("Jackie Tester")
        expect(page).to have_content("Pupper McDog")
      end

      within "#not-tax-included" do
        expect(page).to have_content("Joe Schmoe")
        expect(page).to have_content("Apples McMackintosh")
        expect(page).to have_content("Kitty DeRat")
      end

      click_on "Add a person"
    end

    ginny = {
      first_name: "Ginny",
      last_name: "Pig",
      relationship: "Child",
      tax_relationship: "Dependent",
    }

    on_page "Healthcare" do
      expect(page).to have_content("Add a person.")

      fill_in "What's their first name?", with: ginny[:first_name]
      fill_in "What's their last name?", with: ginny[:last_name]
      select ginny[:relationship], from: "What is their relationship to you?"
      select_radio question: "How are they included on your tax return?", answer: ginny[:tax_relationship]

      proceed_with "Continue"
    end
    members << ginny

    on_page "Healthcare" do
      expect(page).to have_content("Is there anyone else who can be included on your tax return?")

      within "#tax-included" do
        expect(page).to have_content("Ginny Pig")
      end

      proceed_with "Continue"
    end

    on_page "Household" do
      expect(page).to have_content(
        "Who in the household is currently married?",
      )

      # Jessie Tester checked by default
      # Jonny Tester checked by default
      check "Joe Schmoe"

      proceed_with "Continue"
    end

    on_page "Caretaker" do
      expect(page).to have_content(
        "Is anyone a caretaker or parent of other people in the household?",
      )

      proceed_with "Yes"
    end

    on_page "Caretaker" do
      expect(page).to have_content(
        "Who is a caretaker?",
      )

      check "Joe Schmoe"

      proceed_with "Continue"
    end

    on_page "Students" do
      expect(page).to have_content(
        "Is anyone a college or vocational school student?",
      )

      proceed_with "Yes"
    end

    on_page "Students" do
      expect(page).to have_content(
        "Who is a college or vocational school student?",
      )

      check "Joe Schmoe"

      proceed_with "Continue"
    end

    on_page "Disability" do
      expect(page).to have_content(
        "Does anyone have a disability?",
      )

      proceed_with "Yes"
    end

    on_page "Disability" do
      expect(page).to have_content(
        "Who has a disability?",
      )

      check "Joe Schmoe"

      proceed_with "Continue"
    end

    on_page "Veterans" do
      expect(page).to have_content("Is anyone a veteran of the military?")

      proceed_with "Yes"
    end

    on_page "Veterans" do
      expect(page).to have_content(
        "Who is a veteran of the military?",
      )

      check "Joe Schmoe"

      proceed_with "Continue"
    end

    on_page "Foster Care" do
      expect(page).to have_content("Was anyone in foster care when they turned 18?")

      proceed_with "Yes"
    end

    on_page "Foster Care" do
      expect(page).to have_content(
        "Who was in foster care when they turned 18?",
      )

      check "Joe Schmoe"

      proceed_with "Continue"
    end

    on_page "Citizenship" do
      expect(page).to have_content("Is everyone currently a US Citizen?")

      proceed_with "No"
    end

    on_page "Citizenship" do
      expect(page).to have_content(
        "Who is not currently a US Citizen?",
      )

      check "Joe Schmoe"

      proceed_with "Continue"
    end

    on_page "Citizenship" do
      expect(page).to have_content(
        "Do you have any information about immigration status on hand? (like ID types and numbers)",
      )

      proceed_with "Yes"
    end

    on_page "Household Expenses" do
      expect(page).to have_content("What kind of housing expenses do you have?")

      check "Rent"

      proceed_with "Continue"
    end

    on_page "Household Expenses" do
      expect(page).to have_content("Do you have any separate utility expenses?")

      check "Heat"

      proceed_with "Continue"
    end

    on_page "Household Expenses" do
      expect(page).to have_content("Does anyone pay for dependent care?")

      proceed_with "Yes"
    end

    on_page "Household Expenses" do
      expect(page).to have_content("Does anyone pay for child care?")

      proceed_with "Yes"
    end

    on_page "Household Expenses" do
      expect(page).to have_content("Does anyone pay for child support?")

      proceed_with "Yes"
    end

    on_page "Household Expenses" do
      expect(page).to have_content("Does anyone pay for alimony or spousal support?")

      proceed_with "Yes"
    end

    on_page "Household Expenses" do
      expect(page).to have_content("Does anyone pay for interest on student loans?")

      proceed_with "Yes"
    end

    on_page "Current Healthcare" do
      expect(page).to have_content("Is anyone currently enrolled in a health insurance plan?")

      proceed_with "Yes"
    end

    on_page "Current Healthcare" do
      expect(page).to have_content(
        "Who is currently enrolled in a health insurance plan?",
      )

      check "Pupper McDog"

      proceed_with "Continue"
    end

    on_page "Medical Bills" do
      expect(page).to have_content(
        "Does anyone in your household pay for ongoing medical expenses?",
      )

      check "Dental"

      proceed_with "Continue"
    end

    on_page "Medical Bills" do
      expect(page).to have_content(
        "Does anyone need help paying for medical bills from the last 3 months?",
      )

      proceed_with "Yes"
    end

    on_page "Medical Bills" do
      expect(page).to have_content(
        "Who has medical bills from the past 3 months?",
      )

      check "Jonny Tester"

      proceed_with "Continue"
    end

    on_page "Pregnancy" do
      expect(page).to have_content("Is anyone pregnant?")

      proceed_with "Yes"
    end

    on_page "Pregnancy" do
      expect(page).to have_content(
        "Who is pregnant?",
      )

      check "Joe Schmoe"

      proceed_with "Continue"
    end

    on_page "Pregnancy" do
      expect(page).to have_content("Is Joe expecting more than one baby?")

      fill_in "form[baby_count]", with: "2"

      proceed_with "Continue"
    end

    on_page "Pregnancy" do
      expect(page).to have_content(
        "Does anyone have medical bills related to pregnancy from the last three months?",
      )

      proceed_with "Yes"
    end

    on_page "Pregnancy" do
      expect(page).to have_content(
        "Who has medical bills related to pregnancy from the last three months?",
      )

      check "Pupper McDog"

      proceed_with "Continue"
    end

    on_page "Flint Water Crisis" do
      expect(page).to have_content(
        "Has anyone been affected by the Flint Water Crisis?",
      )

      proceed_with "Yes"
    end

    on_page "Flint Water Crisis" do
      expect(page).to have_content(
        "Who has been affected by the Flint Water Crisis?",
      )

      check "Ginny Pig"

      proceed_with "Continue"
    end

    on_page "Income and Employment" do
      expect(page).to have_content(
        "Has your household had a change in income in the past 30 days?",
      )

      proceed_with "Yes"
    end

    on_page "Income and Employment" do
      expect(page).to have_content(
        "In your own words, tell us about the recent change in your household's income.",
      )

      fill_in "form[income_changed_explanation]", with: "I lost my job."

      proceed_with "Continue"
    end

    on_page "Income and Employment" do
      expect(page).to have_content(
        "Who currently has a job?",
      )

      fill_in "How many jobs do you have?", with: "1"
      fill_in "How many jobs does Jonny Tester have?", with: "2"

      proceed_with "Continue"
    end

    on_page "Income and Employment" do
      expect(page).to have_content(
        "Tell us about your job.",
      )

      fill_in "Employer Name", with: "Cogswell's Cogs"
      select_radio(question: "Are you hourly or salaried?", answer: "Hourly")
      fill_in "How much do you make an hour?", with: "20"
      select_radio(question: "How often do you get a paycheck?", answer: "Every two weeks")

      proceed_with "Continue"
    end

    on_page "Income and Employment" do
      expect(page).to have_content(
        "Tell us about Jonny's jobs.",
      )

      within "#job-1" do
        fill_in "Employer Name", with: "Cogswell's Cogs"
        select_radio(question: "Is Jonny hourly or salaried?", answer: "Hourly")
        fill_in "How much does Jonny make an hour?", with: "20"
        select_radio(question: "How often does Jonny get a paycheck?", answer: "Every two weeks")
      end

      within "#job-2" do
        fill_in "Employer Name", with: "Cogswell's Cogs"
        select_radio(question: "Is Jonny hourly or salaried?", answer: "Hourly")
        fill_in "How much does Jonny make an hour?", with: "20"
        select_radio(question: "How often does Jonny get a paycheck?", answer: "Every two weeks")
      end

      proceed_with "Continue"
    end

    on_page "Income and Employment" do
      expect(page).to have_content(
        "Is anyone self-employed in any way?",
      )

      proceed_with "Yes"
    end

    on_page "Income and Employment" do
      expect(page).to have_content(
        "Who is self-employed?",
      )

      check "Ginny Pig"

      proceed_with "Continue"
    end

    on_page "Income and Employment" do
      expect(page).to have_content(
        "Tell us about Ginny's self-employment",
      )

      fill_in "What type of work is it?", with: "Cake making"
      fill_in "About how much income does Ginny make per month", with: "400"
      fill_in "About how much does Ginny spend on business expenses per month", with: "300"

      proceed_with "Continue"
    end

    on_page "Income and Employment" do
      expect(page).to have_content(
        "Do you get income from any of these sources?",
      )

      check "Unemployment"
      check "Child Support"

      proceed_with "Continue"
    end

    members.each do |member|
      on_page "Income and Employment" do
        expect(page).to have_content(
          "Does #{member[:first_name]} get income from any of these sources?",
        )

        proceed_with "Continue"
      end
    end

    on_page "Income and Employment" do
      expect(page).to have_content(
        "Tell us about your income sources",
      )

      fill_in "Unemployment", with: "100"
      fill_in "Child Support", with: "50"

      proceed_with "Continue"
    end

    on_page "Assets" do
      expect(page).to have_content(
        "Does anyone have money in accounts?",
      )

      proceed_with "Yes"
    end

    on_page "Assets" do
      expect(page).to have_content(
        "Is there more than $100 in all of those accounts?",
      )

      proceed_with "Yes"
    end

    on_page "Assets" do
      expect(page).to have_content(
        "Does anyone own vehicles?",
      )

      proceed_with "Yes"
    end

    on_page "Assets" do
      expect(page).to have_content(
        "Does anyone own real estate or property?",
      )

      check "House(s)"

      proceed_with "Continue"
    end

    on_page "Finishing Up" do
      expect(page).to have_content(
        "Would you like to designate someone as your authorized representative?",
      )

      proceed_with "Yes"
    end

    on_page "Finishing Up" do
      expect(page).to have_content(
        "Who would you like to be your authorized representative?",
      )

      fill_in "What's their full, legal name?", with: "Trusty McTrusterson"
      fill_in "What's their phone number?", with: "2024561111"

      proceed_with "Continue"
    end

    on_page "Finishing Up" do
      expect(page).to have_content(
        "Provide your Social Security Number if you're ready",
      )

      fill_in "Social Security Number", with: "123456789"

      proceed_with "Continue"
    end

    on_page "Finishing Up" do
      expect(page).to have_content("Before you finish, read and agree to the legal terms.")

      choose "I agree"

      proceed_with "Continue"
    end

    on_page "Finishing Up" do
      expect(page).to have_content("Enter your full legal name here to sign this application.")

      fill_in "Sign by typing your full legal name", with: "Jessie Tester"

      proceed_with "Sign and submit"
    end

    on_page "Application Submitted" do
      expect(page).to have_content(
        "Congratulations",
      )
    end

    emails = ActionMailer::Base.deliveries

    raw_application_pdf = emails.last.attachments.first.body.raw_source
    temp_file = write_raw_pdf_to_temp_file(source: raw_application_pdf)
    pdf_values = filled_in_values(temp_file.path)

    # Test minimal info to make sure PDF isn't corrupted

    expect(pdf_values["legal_name"]).to include("Jessie Tester") # Main application
    expect(pdf_values["notes"]).to include("Additional Household Members:") # Additional info
    expect(pdf_values["anyone_buys_food_separately"]).to eq("Yes") # Food assistance supplement
    expect(pdf_values["anyone_filing_taxes"]).to eq("Yes") # Healthcare coverage supplement
  end
end
