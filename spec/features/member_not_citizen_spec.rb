require "rails_helper"

feature "Citizenship questions" do
  scenario "Member not a citizen" do
    visit root_path
    within(".slab--hero") { click_on "Apply for FAP" }

    fill_in_name_and_birthday("Naan", "Citizen")
    click_on "Continue"

    visit "/steps/household-members-overview"

    click_on "Add a member"

    fill_in "What is their first name?", with: "Other"
    fill_in "What is their last name?", with: "Citizen"
    fill_in_birthday
    choose "Male"
    select "Roommate"
    click_on "Continue"

    visit "/steps/household-more-info"

    answer_household_more_info_questions(js: false)
    select_radio(
      question: "Is each person a US citizen/national?",
      answer: "No",
    )
    click_on "Continue"

    within(
      find(
        :fieldset,
        text: t("snap.household_more_info_per_member.edit.prompt"),
      ),
    ) do
      check "Other Citizen"
    end
    click_on "Continue"

    member_one = Member.find_by(first_name: "Naan", last_name: "Citizen")
    member_two = Member.find_by(first_name: "Other", last_name: "Citizen")

    expect(member_one.citizen).to eq false
    expect(member_two.citizen).to eq true
  end

  def fill_in_name_and_birthday(first_name, last_name)
    fill_in "What is your first name?", with: first_name
    fill_in "What is your last name?", with: last_name
    fill_in_birthday
  end
end
