require "rails_helper"

feature "Citizenship questions" do
  scenario "Member not a citizen" do
    visit root_path
    within(".slab--hero") { click_on "Apply now" }

    fill_in_name_and_birthday
    click_on "Continue"

    visit "/steps/household-more-info"

    answer_household_more_info_questions(js: false)
    select_radio(
      question: "Is each person a US citizen/national?",
      answer: "No",
    )
    click_on "Continue"

    within(find(:fieldset, text: "Who is not a citizen?")) do
      check "Naan Citizen"
    end
    click_on "Continue"

    member = Member.find_by(first_name: "Naan", last_name: "Citizen")

    expect(member.citizen).to eq false
  end

  def fill_in_name_and_birthday
    fill_in "What is your first name?", with: "Naan"
    fill_in "What is your last name?", with: "Citizen"
    fill_in_birthday
  end
end
