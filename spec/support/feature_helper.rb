# frozen_string_literal: true

module FeatureHelper
  def add_document_photo(url)
    input = %(<input type="hidden" name="step[documents][]" value="#{url}">)
    page.execute_script(
      <<~eos
        document.querySelector('[data-documents-form]').
          insertAdjacentHTML('beforeend', '#{input}')
      eos
    )
  end

  def answer_household_more_info_questions(js: true)
    select_radio(
      question: "Is each person a US citizen/national?",
      answer: "Yes",
    )
    select_radio(
      question: "Does anyone have a disability?",
      answer: "No",
    )
    answer_pregnancy_question(js)
    select_radio(
      question: "Is anyone enrolled in college or vocational school?",
      answer: "No",
    )
    select_radio(
      question: "Is anyone temporarily living outside the home?",
      answer: "No",
    )
  end

  def answer_pregnancy_question(js)
    if js == true
      js_select_radio(
        question: "Is anyone pregnant or has been pregnant recently?",
        answer_id: "step_anyone_new_mom_false",
      )
    else
      select_radio(
        question: "Is anyone pregnant or has been pregnant recently?",
        answer: "No",
      )
    end
  end

  def select_radio(question:, answer:)
    within(find(:fieldset, text: question)) do
      choose answer
    end
  end

  def js_select_radio(question:, answer_id:)
    within(find(:fieldset, text: question)) do
      page.execute_script("$('##{answer_id}').trigger('click')")
    end
  end

  def on_page(page_title)
    expect(page.title).to eq page_title
    yield
  end
end
