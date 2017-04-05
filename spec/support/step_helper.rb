module StepHelper
  def check_step(subhead, *questions, verify: true, validations: true)
    log subhead do
      expect_page(subhead)

      if validations
        log "Checking validation errors" do
          submit
          expect_validation_errors(questions)
        end
      end

      log "Answering questions" do
        enter_questions(questions)
        submit
      end

      if verify
        log "Verifying that answers were saved" do
          back
          verify_questions(questions)
          submit
        end
      end
    end
  end

  def check_household_step(subhead, members_and_questions, verify: true, validations: true)
    log subhead do
      expect_page(subhead)

      if validations
        log "Checking validation errors" do
          submit
          within_members(members_and_questions) do |questions|
            expect_validation_errors(questions)
          end
        end
      end

      log "Answering questions" do
        within_members(members_and_questions) do |questions|
          enter_questions(questions)
        end
        submit
      end

      if verify
        log "Verifying that answers were saved" do
          back
          within_members(members_and_questions) do |questions|
            verify_questions(questions)
          end
          submit
        end
      end
    end
  end

  def within_members(members_and_questions)
    members_and_questions.each do |member, questions|
      within_member(member) do
        yield questions
      end
    end
  end

  def verify_questions(questions)
    questions.each { |q, a, _| verify(q, a) }
  end

  def enter_questions(questions)
    questions.each { |q, a, _| enter(q, a) }
  end

  def expect_validation_errors(questions)
    questions.each { |q, _, e| expect_validation_error q, e }
  end

  def expect_page(subhead)
    log "Checking page title" do
      expect(page).to have_selector \
      ".step-section-header__subhead",
        text: subhead
    end
  end

  def static_step(subhead)
    expect_page subhead
    submit
  end

  def within_member(member_name)
    within(".household-member-group[data-md5='#{Digest::MD5.hexdigest(member_name)}']") do
      yield
    end
  end

  def within_question(question)
    begin
      group = find(<<~CSS, visible: false)
        .household-member-group[data-md5='#{Digest::MD5.hexdigest(question)}'],
        .form-questions-group[data-md5='#{Digest::MD5.hexdigest(question)}'],
        .form-group[data-md5='#{Digest::MD5.hexdigest(question)}']
      CSS
    rescue
      raise %|Could not find question: "#{question}" on "#{find('.step-section-header__subhead').text}"|
    end

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
        type = group['data-field-type']

        case type
          when "date"
            date = Date.today - 40.years
            date_parts = [date.month, date.day, date.year]

            all('select').each_with_index do |date_select, i|
              select date_parts[i], from: date_select[:name]
            end
          when "text", "incrementer", 'text_area', "money"
            fill_in question, with: answer
          when "yes_no", "radios"
            choose answer
          when "select"
            select answer
          when "checkbox"
            if answer.is_a?(Array)
              answer.each do |checkbox|
                check checkbox
              end
            elsif answer
              check question
            else
              uncheck question
            end
          else
            fill_in question, with: answer
        end
      end
    end
  end

  def verify(question, expected_answer)
    log "#{question} => #{expected_answer}" do
      within_question(question) do |group|
        type = group['data-field-type']

        case type
          when "text_area"
            expect(find("textarea").value).to eq expected_answer
          when "text", 'incrementer', "money"
            expect(find("input").value).to eq expected_answer
          when "yes_no", 'radios'
            expect(find("label", exact_text: expected_answer).find("input").checked?).to eq true
          when 'select'
            expect(page).to have_select(question, selected: expected_answer)
          when "checkbox"
            if expected_answer.is_a?(Array)
              expected_answer.each do |checkbox|
                expect(find("label", text: checkbox).find("input")).to be_checked
              end
            else
              expect(find("input").checked?).to eq(expected_answer)
            end
        end
      end
    end
  end

  def submit
    log "Continuing" do
      first('button[type="submit"]').click
    end
  end

  def back
    log "Going back" do
      first('.step-header__back-link').trigger('click')
    end
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
