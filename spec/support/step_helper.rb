module StepHelper
  def check_step(subhead, *questions, household_members: nil, verify: true, validations: true)
    log subhead do
      expect_page(subhead)

      if validations
        log "Checking validation errors" do
          submit
          maybe_member_questions(household_members, questions) do |qq|
            qq.each { |q, _, e| expect_validation_error q, e }
          end
        end
      end

      log "Answering questions" do
        maybe_member_questions(household_members, questions) do |qq|
          qq.each { |q, a, _| enter(q, a) }
        end
        submit
      end

      if verify
        log "Verifying that answers were saved" do
          back
          maybe_member_questions(household_members, questions) do |qq|
            qq.each { |q, a, _| verify(q, a) }
          end
          submit
        end
      end
    end
  end

  def maybe_member_questions(hash, array)
    if hash
      hash.each do |member, qq|
        within_member(member) do
          yield qq
        end
      end
    else
      yield array
    end
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
          else
            raise "Unsupported type: #{type}"
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
