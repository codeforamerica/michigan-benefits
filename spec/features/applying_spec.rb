require "rails_helper"

describe "applying", js: true do
  specify do
    visit root_path

    click_on "Start Now"

    check_step "To start, please introduce yourself.",
      ["What is your first name?", "Alice", "Make sure to provide a first name"],
      ["What is your last name?", "Aardvark", "Make sure to provide a last name"],
      ["What is the best phone number to reach you?", "415-867-5309", "Make sure your phone number is 10 digits long"],
      ["May we send text messages to that phone number help you through the enrollment process?", "Yes", "Make sure to answer this question"]
  end

  def check_step(subhead, *questions)
    expect(find(".subhead").text).to eq subhead

    continue
    questions.each { |q, _, e| expect_validation_error q, e }

    questions.each { |q, a, _| enter(q, a)}
    continue

    back
    questions.each { |q, a, _| verify(q, a)}
    continue
  end

  def within_question(question)
    within("label", text: question) do
      yield
    end
  end

  def expect_validation_error(question, expected_error)
    within_question(question) do
      expect(page).to have_text expected_error
    end
  end

  def enter(question, answer)
    type = find("label", text: question)["data-field-type"]
    case type
      when "text"
        fill_in question, with: answer
      when "yes_no"
        within_question(question) do
          choose answer
        end
      else
        raise "Unsupported type: #{type}"
    end
  end

  def verify(question, expected_answer)
    type = find("label", text: question)["data-field-type"]

    within_question(question) do
      case type
        when "text"
          expect(find("input").value).to eq expected_answer
        when "yes_no"
          expect(find("label", text: expected_answer).find("input").checked?).to eq true
        else
          raise "Unsupported type: #{type}"
      end
    end
  end

  def continue
    click_on "Continue"
  end

  def back
    click_on "Go back"
  end
end
