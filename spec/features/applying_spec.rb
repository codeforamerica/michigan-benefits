require "rails_helper"

describe "applying", js: true do
  specify do
    visit root_path

    click_on "Apply Now"

    step "To start, please introduce yourself." do |s|
      enter "What is your first name?", "Alice"
      enter "What is your last name?", "Aardvark"
      enter "What is the best phone number to reach you?", "415-867-5309"
      enter "May we send text messages to that phone number help you through the enrollment process?", "Yes"
      continue

      # back
      # verify "What is your first name?", "Alice"
      # verify "What is your last name?", "Aardvark"
      # verify "What is the best phone number to reach you?", "415-867-5309"
      # verify "May we send text messages to that phone number help you through the enrollment process?", "Yes"
    end
  end

  def enter(question, answer)
    type = find("label", text: question)["data-question-type"]
    case type
      when "text"
        fill_in question, with: answer
      when "yes_no"
        within("label", text: question) do
          choose answer
        end
      else
        raise "Unsupported type: #{type}"
    end
  end

  def verify(question, expected_answer)
    within("label", text: question) do
      expect(find("input").value).to eq expected_answer
    end
  end

  def continue
    click_on "Continue"
  end

  def back
    click_on "Go back"
  end
end
