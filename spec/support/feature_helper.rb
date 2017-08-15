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

  def select_radio(question:, answer:)
    within(find(:fieldset, text: question)) do
      choose answer
    end
  end

  def on_page(page_title)
    expect(page.title).to eq page_title
    yield
  end
end
