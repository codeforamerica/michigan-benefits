module SnapApplicationFormHelper
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

  def answer_household_more_info_questions(js: true)
    select_radio(
      question: "Is each person a US citizen/national?",
      answer: "Yes",
    )
    select_radio(
      question: "Does anyone have a disability?",
      answer: "No",
    )
    answer_pregnancy_question(js)
    select_radio(
      question: "Is anyone enrolled in college or vocational school?",
      answer: "No",
    )
    select_radio(
      question: "Is anyone temporarily living outside the home?",
      answer: "No",
    )
  end

  def answer_pregnancy_question(js)
    if js == true
      js_select_radio(
        question: "Is anyone pregnant or has been pregnant recently?",
        answer_id: "step_anyone_new_mom_false",
      )
    else
      select_radio(
        question: "Is anyone pregnant or has been pregnant recently?",
        answer: "No",
      )
    end
  end

  def select_employment(full_name:, employment_status:)
    within(".household-member-group[data-member-name='#{full_name}']") do
      choose(employment_status)
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
        "Does your household have ongoing medical expenses?",
      )
      send(
        "choose_#{answer}",
        "Does your household have court-ordered expenses?",
      )
      click_on "Continue"
    end
  end

  def consent_to_terms
    choose "I agree"
    click_on "Continue"
  end
end
