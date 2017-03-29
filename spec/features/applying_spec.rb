require "rails_helper"

describe "applying", js: true do
  before do
    allow(FormMailer).to receive_message_chain(:submission, :deliver_now)
  end

  around(:each) do |example|
    with_modified_env FORM_RECIPIENT: 'test@example.com' do
      example.run
    end
  end

  specify do
    visit root_path

    click_on "Apply now"

    check_step "To start, please introduce yourself.",
      ["What is your first name?", "Alice", "Make sure to provide a first name"],
      ["What is your last name?", "Aardvark", "Make sure to provide a last name"]

    check_step "Tell us the best ways to reach you.",
      ["What is the best phone number to reach you?", "4158675309", "Make sure your phone number is 10 digits long"],
      ["May we send text messages to that phone number help you through the enrollment process?", "Yes", "Make sure to answer this question"],
      ["What is your email address?", "test@example.com", nil],
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

    expect_page "There are 4 sections you need to complete to submit a full application."
    continue

    expect_page "Next, describe your financial situation for us."
    continue

    check_step "Has your household had a change in income in the past 30 days?",
      ["Income change", "Yes", nil]

    check_step "In your own words, tell us about the recent change in your household's income.",
      ["Explanation", "I lost my job", nil],
      validations: false

    expect(page).to have_text("Scroll down to agree")
    continue

    check_step "Enter your full legal name here to sign this application.",
      ["Your signature", "Jeff Name", "Make sure you enter your signature"],
      verify: false

    check_doc_uploads

    click_on "I'm finished"

    expect_application_to_be_submitted
  end

  def expect_application_to_be_submitted
    expect(page).to have_text \
      "Your application has been successfully submitted."
  end

  def delete_first_attachment
    attachment = first('.attachment-preview')

    within attachment do
      click_on "Delete"
    end
  end

  def expect_page_to_have_attachments(count:)
    expect(page).to have_selector(".attachment-preview", count: count)
  end

  def upload_file(file)
    click_on "Add a document"

    attach_file "document_file", attachment_file_path(file)
    click_on "Upload"
  end

  def check_step(subhead, *questions, verify: true, validations: true)
    log subhead do
      expect_page(subhead)

      if validations
        log "Checking validation errors" do
          continue
          questions.each { |q, _, e| expect_validation_error q, e }
        end
      end

      log "Answering questions" do
        questions.each { |q, a, _| enter(q, a)}
        continue
      end

      if verify
        log "Verifying that answers were saved" do
          back
          questions.each { |q, a, _| verify(q, a)}
          continue
        end
      end
    end
  end

  def expect_page(subhead)
    log "Checking page title" do
      expect(page).to have_selector \
      ".step-section-header__subhead",
        text: subhead
    end
  end

  def within_question(question)
    label = find(".form-group label", text: question, visible: false)

    group = label.first(
      :xpath,
      "ancestor::*[local-name()='div' and contains(@class, 'form-group')]"
    )

    within(group) do
      yield group
    end
  end

  def expect_validation_error(question, expected_error)
    if expected_error.present?
      log "#{question} => #{expected_error}" do
        within_question(question) do
          expect(page).to have_text expected_error
        end
      end
    end
  end

  def enter(question, answer)
    log "#{question} => #{answer}" do
      within_question(question) do |group|
        case group['data-field-type']
        when "text", "text_area"
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
  end

  def verify(question, expected_answer)
    log "#{question} => #{expected_answer}" do
      within_question(question) do |group|
        type = group['data-field-type']
        case type
        when "text"
          expect(find("input").value).to eq expected_answer
        when "text_area"
          expect(find("textarea").value).to eq expected_answer
        when "yes_no"
          expect(find("label", text: expected_answer).find("input").checked?).to eq true
        when "checkbox"
          expect(find("input").checked?).to eq(expected_answer)
        else
          raise "Unsupported type: #{type}"
        end
      end
    end
  end

  def attachment_file_path(file)
    Rails.root.join("spec/fixtures/uploads/#{file}")
  end

  def continue
    log "Continuing" do
      first('button[type="submit"]').click
    end
  end

  def back
    log "Going back" do
      first('.step-header__back-link').trigger('click')
    end
  end

  def check_doc_uploads
    click_on "Submit documents now"

    expect(page).to have_text("No documents uploaded yet.")

    upload_file("kermit.jpg")
    expect_page_to_have_attachments(count: 1)

    upload_file("oscar.jpg")
    expect_page_to_have_attachments(count: 2)

    delete_first_attachment
    expect_page_to_have_attachments(count: 1)

    upload_file("bad.txt")

    expect(page).to have_text("Invalid file type")

    back

    expect_page_to_have_attachments(count: 1)
  end

  def log(message)
    if ENV["VERBOSE_TESTS"]
      @log_depth ||= 0
      puts ">> #{' ' * @log_depth}#{message}"
      @log_depth += 2
      yield
      @log_depth -= 2
    else
      yield
    end
  end
end
