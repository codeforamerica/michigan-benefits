class CreateAccountPage
  # https://www.mibridges.michigan.gov/access/accessController

  def fill_in_required_fields
    fill_in_first_name
    fill_in_last_name
    fill_in_user_id
    fill_in_password
    confirm_password
    select_secret_question_1
    answer_secret_question_1
    select_secret_question_2
    answer_secret_question_2
    accept_user_agreement
  end

  def user_id
    # generate and memoize random string
  end

  def password
    # 8-16 digits, only numbers and letters
    # generate and memoize random string
  end

  def submit; end

  private

  def fill_in_first_name; end

  def fill_in_last_name; end

  def fill_in_user_id; end

  def fill_in_password; end

  def confirm_password; end

  def select_secret_question_1; end

  def answer_secret_question_1; end

  def select_secret_question_2; end

  def answer_secret_question_2; end

  def accept_user_agreement; end
end
