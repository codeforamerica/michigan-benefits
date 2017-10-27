require "rails_helper"

RSpec.feature "Medicaid app" do
  scenario "with minimal info", :js do
    visit medicaid_root_path

    within(".slab--hero") do
      click_on "Apply for Medicaid"
    end

    on_pages "Introduction" do
      click_on "Yes"

      fill_in "What is your first name?", with: "Jessie"
      fill_in "What is your last name?", with: "Tester"
      select_radio(question: "What is your gender?", answer: "Female")
      click_on "Next"

      expect(page).to have_content(
        "Now tell us about any other people residing in your household.",
      )
      click_on "Next"

      expect(page).to have_content("Are you currently a college student?")
      click_on "No"

      expect(page).to have_content(
        "Are you currently a US citizen",
      )
      click_on "No"
    end

    on_pages "Health Coverage Needs" do
      expect(page).to have_content(
        "Are you currently enrolled in a health insurance plan?",
      )
      click_on "No"

      expect(page).to have_content(
        "Do you need help paying for medical expenses from the last 3 months?",
      )
      click_on "No"
    end

    on_pages "Quick Health Questions" do
      expect(page).to have_content("Do you have a disability?")
      click_on "No"

      expect(page).to have_content("Have you been pregnant recently?")
      click_on "No"

      expect(page).to have_content(
        "Have you been affected by the Flint Water Crisis?",
      )
      click_on "No"
    end

    on_pages "Quick Tax Question" do
      expect(page).to have_content(
        "Do you plan on filing a federal tax return next year?",
      )

      click_on "No"
    end

    on_pages "Current Income" do
      expect(page).to have_content("Do you currently have a job?")
      click_on "No"

      expect(page).to have_content("Are you self-employed?")
      click_on "No"

      expect(page).to have_content("Do you get income that’s not from a job?")
      click_on "No"
    end

    on_pages "Current Expenses" do
      expect(page).to have_content(
        "Do you pay child support, alimony, or arrears?",
      )
      click_on "No"

      expect(page).to have_content("Do you pay student loan interest?")
      click_on "No"

      expect(page).to have_content(
        "Okay, thanks! Now describe your income and expenses.",
      )
      click_on "Next"
    end

    on_pages "Contact Information & Followup" do
      expect(page).to have_content(
        "Do you receive mail at your current residential address?",
      )
      click_on "No"

      expect(page).to have_content(
        "Is there somewhere we can reliably send you mail?",
      )

      click_on "No"

      expect(page).to have_content(
        "Are you currently homeless?",
      )
      click_on "No"

      expect(page).to have_content(
        "What is your residential address?",
      )
      fill_in "Street address", with: "123 Some St."
      fill_in "City", with: "Flint"
      fill_in "ZIP code", with: "48501"
      click_on "Next"

      expect(page).to have_content(
        "What is the best number for you to receive phone calls?",
      )
      fill_in "Phone number", with: "8005550000"
      click_on "Next"

      expect(page).to have_content(
        "What is the best number for you to receive text messages?",
      )
      click_on "Next"

      expect(page).to have_content(
        "What is the best email address at which to contact you?",
      )
      click_on "Next"

      expect(page).to have_content(
        "Provide your Social Security Number and Date of Birth if you’re ready",
      )
      click_on "No"
    end

    on_page "Confirmation" do
      click_on "No"
    end

    expect(page).to have_content("Get the support your family needs")
  end
end
