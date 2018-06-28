require "rails_helper"

RSpec.feature "Integrated application" do
  scenario "with one member", :js do
    visit root_path

    within(".slab--hero") do
      proceed_with "Start your application"
    end

    on_page "Introduction" do
      expect(page).to have_content("Which programs do you want to apply for today?")
      check "Food Assistance Program"
      check "Healthcare Coverage"

      proceed_with "Continue"
    end

    on_page "Introduction" do
      expect(page).to have_content("Welcome")

      proceed_with "Continue"
    end

    on_page "Introduction" do
      expect(page).to have_content("Do you currently reside in Michigan?")

      proceed_with "Yes"
    end

    on_page "Introduction" do
      expect(page).to have_content("Which office are you in?")

      choose "Clio Road"
      proceed_with "Continue"
    end

    on_page "Introduction" do
      expect(page).to have_content("To start, please introduce yourself")

      fill_in "What's your first name?", with: "Jessie"
      fill_in "What's your last name?", with: "Tester"

      fill_in "Month", with: "1"
      fill_in "Day", with: "1"
      fill_in "Year", with: "1998"

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
        answer: "Temporary address",
      )

      proceed_with "Continue"
    end

    on_page "Introduction" do
      expect(page).to have_content("Tell us where to send you postal mail.")

      fill_in "Street address", with: "123 Main St"
      fill_in "Street address 2", with: "Floor 2"
      fill_in "City", with: "Flint"
      fill_in "ZIP code", with: "48550"

      proceed_with "Continue"
    end

    on_page "Introduction" do
      expect(page).to have_content("What's the best number for you to receive phone calls?")

      fill_in "Phone number", with: "2024561111"

      proceed_with "Continue"
    end

    on_page "Your Household" do
      expect(page).to have_content("Okay thanks! Now tell us about your household.")

      proceed_with "Continue"
    end

    on_page "Your Household" do
      expect(page).to have_content(
        "Who do you want to include on your Food Assistance application?",
      )

      proceed_with "Continue"
    end

    on_page "Review" do
      expect(page).to have_content(
        "Here's who's applying for Food Assistance with you:",
      )

      within "#applying-with-you" do
        expect(page).to have_content("Jessie Tester (that's you!)")
      end

      proceed_with "Continue"
    end

    on_page "Healthcare" do
      expect(page).to have_content("Will you file taxes this year?")

      proceed_with "Yes"
    end

    on_page "Healthcare" do
      expect(page).to have_content("Who will you file taxes with?")

      expect(page).to have_content("Jessie Tester (that's you!)")

      proceed_with "Continue"
    end

    on_page "Household" do
      expect(page).to have_content("Getting to know you")

      proceed_with "Continue"
    end

    on_page "Household" do
      expect(page).to have_content("Are you married?")

      proceed_with "Yes"
    end

    on_page "Students" do
      expect(page).to have_content("Are you in college?")

      proceed_with "Yes"
    end

    on_page "Disability" do
      expect(page).to have_content("Do you have a disability?")

      proceed_with "Yes"
    end

    on_page "Veterans" do
      expect(page).to have_content("Are you a veteran of the military?")

      proceed_with "Yes"
    end

    on_page "Foster Care" do
      expect(page).to have_content("Were you in foster care when you turned 18?")

      proceed_with "Yes"
    end

    on_page "Citizenship" do
      expect(page).to have_content("Are you currently a US Citizen?")

      proceed_with "Yes"
    end

    on_page "Household Expenses" do
      expect(page).to have_content("Household bills")

      proceed_with "Continue"
    end

    on_page "Household Expenses" do
      expect(page).to have_content("What kind of housing expenses do you have?")

      check "Rent"

      proceed_with "Continue"
    end

    on_page "Household Expenses" do
      expect(page).to have_content("Tell us about your housing expenses.")

      fill_in "Rent", with: "400"

      proceed_with "Continue"
    end

    on_page "Household Expenses" do
      expect(page).to have_content("Do you have any separate utility expenses?")

      proceed_with "Continue"
    end

    on_page "Household Expenses" do
      expect(page).to have_content("Do you pay for child support?")

      proceed_with "No"
    end

    on_page "Household Expenses" do
      expect(page).to have_content("Do you pay for alimony or spousal support?")

      proceed_with "Yes"
    end

    on_page "Household Expenses" do
      expect(page).to have_content("Do you pay for interest on student loans?")

      proceed_with "Yes"
    end

    on_page "Household Expenses" do
      expect(page).to have_content("Tell us about your expenses")

      fill_in "Alimony", with: "200"
      fill_in "Student Loan Interest", with: "50"

      proceed_with "Continue"
    end

    on_page "Healthcare" do
      expect(page).to have_content("Health and insurance")

      proceed_with "Continue"
    end

    on_page "Current Healthcare" do
      expect(page).to have_content("Are you currently enrolled in a health insurance plan?")

      proceed_with "Yes"
    end

    on_page "Medical Bills" do
      expect(page).to have_content(
        "Do you pay for ongoing medical expenses?",
      )

      check "Prescriptions"

      proceed_with "Continue"
    end

    on_page "Medical Bills" do
      expect(page).to have_content(
        "Tell us about your ongoing medical expenses",
      )

      fill_in "Prescriptions", with: "200"

      proceed_with "Continue"
    end

    on_page "Medical Bills" do
      expect(page).to have_content(
        "Do you need help paying for medical bills from the last 3 months?",
      )

      proceed_with "Yes"
    end

    on_page "Pregnancy" do
      expect(page).to have_content("Are you pregnant?")

      proceed_with "Yes"
    end

    on_page "Pregnancy" do
      expect(page).to have_content("Are you expecting more than one baby?")

      fill_in "form[baby_count]", with: "1"

      proceed_with "Continue"
    end

    on_page "Pregnancy" do
      expect(page).to have_content(
        "Do you have medical bills related to pregnancy from the last three months?",
      )

      proceed_with "Yes"
    end

    on_page "Flint Water Crisis" do
      expect(page).to have_content(
        "Have you drunk water in Flint since April 2014?",
      )

      proceed_with "Yes"
    end

    on_page "Income and Employment" do
      expect(page).to have_content("Income and employment")

      proceed_with "Continue"
    end

    on_page "Income and Employment" do
      expect(page).to have_content(
        "Has your income changed in the past 30 days?",
      )

      proceed_with "Yes"
    end

    on_page "Income and Employment" do
      expect(page).to have_content(
        "In your own words, tell us about the recent change in your income.",
      )

      fill_in "form[income_changed_explanation]", with: "I lost my job."

      proceed_with "Continue"
    end

    on_page "Income and Employment" do
      expect(page).to have_content(
        "Do you currently have a job?",
      )

      proceed_with "Yes"
    end

    on_page "Income and Employment" do
      expect(page).to have_content(
        "How many jobs do you have?",
      )

      fill_in "How many jobs do you have?", with: "1"

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
        "Are you self-employed in any way?",
      )

      proceed_with "Yes"
    end

    on_page "Income and Employment" do
      expect(page).to have_content(
        "Tell us about your self-employment",
      )

      fill_in "What type of work is it?", with: "Cake making"
      fill_in "About how much income do you make per month", with: "400"
      fill_in "About how much do you spend on business expenses per month", with: "300"

      proceed_with "Continue"
    end

    on_page "Income and Employment" do
      expect(page).to have_content(
        "Do you get income from any of these sources?",
      )

      check "Unemployment"

      proceed_with "Continue"
    end

    on_page "Income and Employment" do
      expect(page).to have_content(
        "Tell us about your income sources",
      )

      fill_in "Unemployment", with: "100"

      proceed_with "Continue"
    end

    on_page "Assets" do
      expect(page).to have_content("Savings and assets")

      proceed_with "Continue"
    end

    on_page "Assets" do
      expect(page).to have_content(
        "Do you have any money in accounts?",
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
        "Tell us about your accounts.",
      )

      proceed_with "Add an account"
    end

    on_page "Assets" do
      expect(page).to have_content(
        "Add an account.",
      )

      fill_in "What's the name of the bank or institution this account is at?", with: "Test Credit Union"
      select "Checking", from: "What type of account is this?"

      proceed_with "Continue"
    end

    on_page "Assets" do
      expect(page).to have_content(
        "Tell us about your accounts.",
      )
      expect(page).to have_content(
        "Checking: Test Credit Union",
      )

      proceed_with "Continue"
    end

    on_page "Assets" do
      expect(page).to have_content(
        "Do you own any vehicles?",
      )

      proceed_with "Yes"
    end

    on_page "Assets" do
      expect(page).to have_content(
        "Tell us about your vehicles",
      )

      proceed_with "Add a vehicle"
    end

    on_page "Assets" do
      expect(page).to have_content(
        "Add a vehicle",
      )

      select_radio(question: "What type of vehicle is it?", answer: "Truck")
      fill_in "Year, make, and model", with: "1989 Toyota pickup"

      proceed_with "Continue"
    end

    on_page "Assets" do
      expect(page).to have_content(
        "Tell us about your vehicles",
      )
      expect(page).to have_content(
        "Truck: 1989 Toyota pickup",
      )

      proceed_with "Continue"
    end

    on_page "Assets" do
      expect(page).to have_content(
        "Do you own any real estate or property?",
      )

      proceed_with "Continue"
    end

    on_page "Finishing Up" do
      expect(page).to have_content("Finishing up")

      proceed_with "Continue"
    end

    on_page "Finishing Up" do
      expect(page).to have_content("Is there anything else you'd like us to know about your situation?")

      fill_in "Is there anything else you'd like us to know about your situation?",
              with: "Don't know if I'll have a job next month"

      proceed_with "Continue"
    end

    on_page "Finishing Up" do
      expect(page).to have_content(
        "Is there anyone you would like to make your official authorized representative?",
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
      expect(page).to have_content(
        "How can we follow up with you?",
      )

      check "Text message"
      check "Email"

      proceed_with "Continue"
    end

    on_page "Finishing Up" do
      expect(page).to have_content(
        "Tell us where to reach you",
      )

      fill_in "Cell phone number", with: "2024561111"
      fill_in "Email address", with: "jessie@example.com"

      proceed_with "Continue"
    end

    on_page "Finishing Up" do
      expect(page).to have_content(
        "Review your paperwork",
      )

      proceed_with "I'll do this later"
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
  end
end
