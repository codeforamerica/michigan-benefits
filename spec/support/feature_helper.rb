module FeatureHelper
  def choose_yes(text)
    within(find(:fieldset, text: text)) do
      choose "Yes"
    end
  end

  def choose_no(text)
    within(find(:fieldset, text: text)) do
      choose "No"
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
    expect(page.title.strip).to eq page_title
    yield
  end
end
