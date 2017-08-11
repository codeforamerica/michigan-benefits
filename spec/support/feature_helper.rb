# frozen_string_literal: true

module FeatureHelper
  def enable_continue
    page.execute_script %(document.querySelector('button[disabled]').removeAttribute('disabled'))
  end

  def add_document_photo(url)
    input = %(<input type="hidden" name="step[documents][]" value="#{url}">)
    page.execute_script %(document.querySelector('[data-documents-form]').insertAdjacentHTML('beforeend', '#{input}'))
  end

  def on_page(page_title)
    expect(page.title).to eq page_title
    yield
  end
end
