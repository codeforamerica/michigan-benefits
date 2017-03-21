require "rails_helper"

describe "applying", js: true do
  specify do
    visit root_path

    click_on "Apply now"

    check_step "To start, please introduce yourself.",
      ["What is your first name?", "Alice", "Make sure to provide a first name"],
      ["What is your last name?", "Aardvark", "Make sure to provide a last name"]
  end

  def check_step(subhead, *questions)
    expect(page).to have_selector \
      ".step-section-header__subhead",
      text: subhead

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
