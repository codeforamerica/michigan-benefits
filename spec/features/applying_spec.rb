require "rails_helper"

describe "applying", js: true do
  before do
    allow(FormMailer).to receive_message_chain(:submission, :deliver_now)
  end

  around(:each) do |example|
    with_modified_env FORM_RECIPIENT: 'test@example.com',
      TWILIO_PHONE_NUMBER: "8005551212",
      TWILIO_RECIPIENT_WHITELIST: "4158675309" do
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
    submit

    expect(FakeTwilioClient.messages.count).to eq 1

    check_step "Tell us where you currently live.",
      ["Street", "1234 Fake Street", "Make sure to answer this question"],
      ["City", "San Francisco", "Make sure to answer this question"],
      ["ZIP Code", "94110", "Make sure your ZIP code is 5 digits long"],
      ["Check if you do not have stable housing.", false, nil]

    static_step "It should take about 10 more minutes to complete a full application."
    static_step "There are 4 sections you need to complete to submit a full application."

    check_step "Provide us with some personal details.",
      ["What is your sex?", "Female", "Make sure to answer this question."],
      ["What is your marital status?", "Single", "Make sure to answer this question."],
      ["What is your social security number?", "123-45-6789", nil],
      ["How many people are in your household?", "3", nil]

    click_on "Add a household member"

    check_step "Tell us about another person you are applying with.",
      ["What is their first name?", "Cindy", nil],
      ["What is their last name?", "Crayfish", nil],
      ["What is their sex?", "Female", nil],
      ["What is their relationship to you?", "Child", nil],
      ["What is their social security number?", "444-44-4444", nil],
      ["Is this person living in your home?", "Yes", nil],
      ["Do you buy and prepare food with this person?", "Yes", nil],
      validations: false,
      verify: false

    click_on "Add a household member"

    check_step "Tell us about another person you are applying with.",
      ["What is their first name?", "Billy", nil],
      ["What is their last name?", "Bobcat", nil],
      ["What is their sex?", "Male", nil],
      ["What is their relationship to you?", "Sibling", nil],
      ["What is their social security number?", "555-55-5555", nil],
      ["Is this person living in your home?", "Yes", nil],
      ["Do you buy and prepare food with this person?", "Yes", nil],
      validations: false,
      verify: false

    submit

    check_step "Tell us a bit more about your household.",
      ["Is each person a citizen?", "No", nil],
      ["Does anyone have a disability?", "Yes", nil],
      ["Is anyone pregnant or has been pregnant recently?", "Yes", nil],
      ["Does anyone need help paying for recent medical bills?", "Yes", nil],
      ["Is anyone enrolled in college?", "Yes", nil],
      ["Is anyone temporarily living outside the home?", "Yes", nil]

    check_step "Ok, let us know which people these situations apply to.",
      ["Who is a citizen?", ["Billy"], nil],
      ["Who has a disability?", ["Cindy"], nil],
      ["Who is pregnant or has been pregnant recently?", ["Cindy"], nil],
      ["Who needs help paying for recent medical bills?", ["Alice"], nil],
      ["Who is enrolled in college?", ["Alice", "Billy"], nil],
      ["Who is temporarily living outside the home?", ["Alice", "Billy"], nil],
      validations: false

    check_step "Tell us about your household health coverage in the past 3 months.",
      ["Does anyone need help paying for medical bills from the past 3 months?", "No", "Make sure to answer this question"],
      ["Did anyone have insurance through a job and lose it in the last 3 months?", "No", "Make sure to answer this question"],
      validations: false

    expect_page "Ok, let us know which people these situations apply to."
    submit

    check_step "",
      ["Does anyone plan to file a federal tax return next year?", "No", "Make sure to answer this question"],
      validations: false

    expect_page "Describe how your household files taxes."
    submit

    expect_page "Next, describe your financial situation for us."
    submit

    check_step "Has your household had a change in income in the past 30 days?",
      ["Income change", "Yes", nil]

    check_step "In your own words, tell us about the recent change in your household's income.",
      ["Explanation", "I lost my job", nil],
      validations: false

    check_household_step "Who in your household is currently employed, or has been in the past 30 days?", {
      "Alice (that’s you!)" => [["Employment status", "Employed", "Make sure you answer this question"]],
      "Billy" => [["Employment status", "Self Employed", "Make sure you answer this question"]],
      "Cindy" => [["Employment status", "Not Employed", "Make sure you answer this question"]]
    }

    expect_page "Tell us more about your household's employment"
    submit

    check_household_step \
      "Since Alice, Cindy, and Billy's income fluctuates, tell us more about their annual income",
      {
        "Alice (that’s you!)" => [
          ["Expected income this year", "2000"],
          ["Expected income next year", "1000"]
        ],
        "Cindy" => [
          ["Expected income this year", "4000"],
          ["Expected income next year", "1500"]
        ],
        "Billy" => [
          ["Expected income this year", "5000"],
          ["Expected income next year", "1020"]
        ]
      },
      validations: false

    check_step "Check all additional sources of income received by your household, if any.",
      ["Unemployment Insurance", true, nil],
      ["SSI or Disability", false, nil],
      ["Worker's Compensation", true, nil],
      ["Pension", false, nil],
      ["Social Security", true, nil],
      ["Child Support", false, nil],
      ["Foster Care or Adoption Subsidies", true, nil],
      ["Other Income", false, nil],
      validations: false

    check_step "Tell us more about your additional income.",
      ["Unemployment Insurance", "100", "Make sure you answer this question"],
      ["Worker's Compensation", "200", "Make sure you answer this question"],
      ["Social Security", "300", "Make sure you answer this question"],
      ["Foster Care or Adoption Subsidies", "400", "Make sure you answer this question"],
      validations: false

    check_step "Tell us about the assets and money you have on hand.",
      ["Does your household have any money or accounts?", "Yes", "Make sure to answer this question"],
      ["Does your household own any property or real estate?", "Yes", "Make sure to answer this question"],
      ["Does your household own any vehicles?", "No", "Make sure to answer this question"]

    check_step "Tell us more about those assets.",
      ["In total, how much money does your household have in cash and accounts?", "500", nil],
      ["Checking account", true, nil],
      ["Savings account", true, nil],
      ["401k", true, nil],
      ["Life insurance", true, nil],
      ["IRAs", true, nil],
      ["Mutual funds", true, nil],
      ["Stocks", true, nil],
      ["Trusts", true, nil]

    expect_page "Next, describe your household expenses."
    submit
    back

    expect_page "Next, describe your household expenses."
    submit

    check_step "Tell us about your housing expenses.",
      ["How much does your household pay in rent or mortgage each month?", "300", "Make sure to answer this question"],
      ["How much do you pay in property tax each month?", "100", "Make sure to answer this question"],
      ["How much do you pay in insurance each month?", "20", "Make sure to answer this question"]

    check_step "Tell us more about your expenses.",
      ["Does your household have dependent care expenses?", "Yes", "Make sure to answer this question"],
      ["Does your household have medical expenses?", "Yes", "Make sure to answer this question"],
      ["Does your household have court-ordered expenses?", "Yes", "Make sure to answer this question"],
      ["Does your household have tax deductible expenses?", "Yes", "Make sure to answer this question"]

    check_step "Tell us more about the other expenses you listed.",
      ["In total, how much do you pay in care expenses each month?", "100", "Make sure to answer this question"],
      ["Childcare", true, nil],
      ["In total, how much do you pay in medical expenses each month?", "200", "Make sure to answer this question"],
      ["Transportation", true, nil],
      ["In total, how much do you pay in court ordered expenses each month?", "300", "Make sure to answer this question"],
      ["Alimony", true, nil],
      ["In total, how much do you pay in tax deductible expenses each month?", "400", "Make sure to answer this question"],
      ["Student loan interest", true, nil]

    expect(page).to have_text("Scroll down to agree")
    submit

    back
    expect_page "Scroll down to agree"
    submit

    check_step "Enter your full legal name here to sign this application.",
      ["Your signature", "Alice Aardvark", "Make sure you enter your signature"],
      verify: false

    check_doc_uploads

    click_on "I'm finished"

    expect_application_to_be_submitted
    expect(FakeTwilioClient.messages.count).to eq 2
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

  def attachment_file_path(file)
    Rails.root.join("spec/fixtures/uploads/#{file}")
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
end
