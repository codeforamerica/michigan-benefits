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
      ["Is this address the same as your home address?", "Yes", "Make sure to answer this question"]

    expect_page("It should take about 10 more minutes to complete a full application.")
    back
    expect_page("Tell us the best ways to reach you.")
    within_question("Is this address the same as your home address?") do
      choose "No"
    end
    continue

    check_step "Tell us where you currently live.",
      ["Street", "1234 Fake Street", "Make sure to answer this question"],
      ["City", "San Francisco", "Make sure to answer this question"],
      ["ZIP Code", "94110", "Make sure your ZIP code is 5 digits long"],
      ["Check if you do not have stable housing", false, nil]

    continue

    check_step "Enter your full legal name here to sign this application.",
      ["Your signature", "Jeff Name", "Make sure you enter your signature"]
  end

  def check_step(subhead, *questions)
    expect_page(subhead)

    continue
    questions.each { |q, _, e| expect_validation_error q, e }

    questions.each { |q, a, _| enter(q, a)}
    continue

    back
    questions.each { |q, a, _| verify(q, a)}
    continue
  end

  def expect_page(subhead)
    log "Expecting page: #{subhead}"
    expect(page).to have_selector \
      ".step-section-header__subhead",
      text: subhead
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
    log "Expecting validation error: #{expected_error} on #{question}"
    within_question(question) do |group|
      expect(page).to have_text expected_error
    end
  end

  def enter(question, answer)
    log "Entering #{answer} on #{question}"

    within_question(question) do |group|
      case group['data-field-type']
      when "text"
        fill_in question, with: answer
      when "yes_no"
        choose answer
      when "checkbox"
        if answer
          check question
        else
          uncheck question
        end
      else
        raise "Unsupported type: #{type}"
      end
    end
  end

  def verify(question, expected_answer)
    log "Verifying #{expected_answer} on #{question}"

    within_question(question) do |group|
      case group['data-field-type']
      when "text"
        expect(find("input").value).to eq expected_answer
      when "yes_no"
        expect(find("label", text: expected_answer).find("input").checked?).to eq true
      when "checkbox"
        expect(find("input").checked?).to eq(expected_answer)
      else
        raise "Unsupported type: #{type}"
      end
    end
  end

  def continue
    log "Continuing"

    first('button[type="submit"]').click
  end

  def back
    log "Going back"
    click_on "Go back"
  end

  def log(message)
    if ENV["VERBOSE_TESTS"]
      puts ">> #{message}"
    end
  end
end
