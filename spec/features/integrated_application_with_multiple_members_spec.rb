require "rails_helper"

RSpec.feature "Integrated application" do
  include PdfHelper

  CIRCLED = Integrated::PdfAttributes::CIRCLED
  UNDERLINED = Integrated::PdfAttributes::UNDERLINED

  scenario "with multiple members", :js do
    visit before_you_start_sections_path

    on_page "Introduction" do
      expect(page).to have_content("Welcome")

      proceed_with "Continue"
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
      expect(page).to have_content("Do you currently reside in Michigan?")

      proceed_with "Yes"
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
      expect(page).to have_content("Every family is different")

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
        dob: ["", "", ""],
        sex: "Female",
        relation: "Parent",
      },
      {
        first_name: "Apples",
        last_name: "McMackintosh",
        dob: ["", "", ""],
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

        select member[:relation], from: "form_relationship"

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

    on_page "Healthcare" do
      expect(page).to have_content("Add a person.")

      fill_in "What's their first name?", with: "Kitty"
      fill_in "What's their last name?", with: "DeRat"

      proceed_with "Continue"
    end

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
      expect(page).to have_content(
        "we'll ask you questions about how you file taxes",
      )

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

    on_page "Healthcare" do
      expect(page).to have_content("Add a person.")
      fill_in "What's their first name?", with: "Ginny"
      fill_in "What's their last name?", with: "Pig"
      select("Dependent", from: "How are they included on your tax return?")

      proceed_with "Continue"
    end

    on_page "Healthcare" do
      expect(page).to have_content("Is there anyone else who can be included on your tax return?")

      within "#tax-included" do
        expect(page).to have_content("Ginny Pig")
      end

      proceed_with "Continue"
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
