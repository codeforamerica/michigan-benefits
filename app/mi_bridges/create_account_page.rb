class CreateAccountPage < Page
  # https://www.mibridges.michigan.gov/access/accessController

  def fill_in_required_fields
    fill_in "First Name", with: primary_member.first_name
    sleep 1
    fill_in "Last Name", with: primary_member.last_name
    sleep 1
    fill_in "User ID", with: user_id
    sleep 1
    fill_in "Password", with: password
    sleep 1
    fill_in "Please re-type your Password", with: password
    sleep 1
    select_secret_question_1
    sleep 1
    fill_in "Answer to Secret Question1", with: answer_secret_question_1
    sleep 1
    select_secret_question_2
    sleep 1
    fill_in "Answer to Secret Question2", with: answer_secret_question_2
    sleep 1
    accept_user_agreement
    sleep 1
  end

  def user_id
    # 5 to 20 letters and/or numbers.
    @_user_id ||= SecureRandom.hex(10)
  end

  def password
    # 8-16 digits, only numbers and letters
    @_password ||= SecureRandom.hex(8)
  end

  def submit
    click_on "Next"
  end

  private

  def primary_member
    @_primary_member ||= snap_application.primary_member
  end

  def select_secret_question_1
    select(
      "What was the FIRST NAME of your best friend when growing up?",
      from: "Secret Question1",
    )
  end

  def answer_secret_question_1
    SecureRandom.hex
  end

  def select_secret_question_2
    select(
      "Who is your favorite president?",
      from: "Secret Question2",
    )
  end

  def answer_secret_question_2
    SecureRandom.hex
  end

  def accept_user_agreement
    page.execute_script("$('.ace').trigger('click')")
  end
end
