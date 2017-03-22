require "rails_helper"

describe "applying", js: true do
  specify do
    visit root_path

    click_on "Apply now"

    check_step "To start, please introduce yourself.",
      ["What is your first name?", "Alice", "Make sure to provide a first name"],
      ["What is your last name?", "Aardvark", "Make sure to provide a last name"]

    check_step "Tell us the best ways to reach you.",
      ["What is the best phone number to reach you?", "4158675309", "Make sure your phone number is 10 digits long"],
      ["May we send text messages to that phone number help you through the enrollment process?", "Yes", "Make sure to answer this question"],
      ["What is your email address?", "test@example.com", "Make sure to answer this question"],
      ["Address", "123 Main St", "Make sure to answer this question"],
      ["City", "San Francisco", "Make sure to answer this question"],
      ["ZIP Code", "94110", "Make sure your ZIP code is 5 digits long"],
      ["Is this address the same as your home address?", "No", "Make sure to answer this question"]
  end

  def check_step(subhead, *questions)
    expect(page).to have_selector \
      ".step-section-header__subhead",
      text: subhead

    # fill_in "What is your email address?", with: "" rescue nil

    continue
    questions.each { |q, _, e| expect_validation_error q, e }

    questions.each { |q, a, _| enter(q, a)}
    continue

    back
    questions.each { |q, a, _| verify(q, a)}
    continue
  end

  def within_question(question)
    label = find(".form-group label", text: question)

    group = label.first(
      :xpath,
      "ancestor::*[local-name()='div' and contains(@class, 'form-group')]"
    )

    within(group) do
      yield group
    end
  end

  def expect_validation_error(question, expected_error)
    within_question(question) do |group|
      expect(page).to have_text expected_error
    end
  end

  def enter(question, answer)
    within_question(question) do |group|
      case group['data-field-type']
      when "text"
        fill_in question, with: answer
      when "yes_no"
        choose answer
      else
        raise "Unsupported type: #{type}"
      end
    end
  end

  def verify(question, expected_answer)
    within_question(question) do |group|
      case group['data-field-type']
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
