# frozen_string_literal: true

module FeatureHelper
  def add_document_photo(url)
    input = %(<input type="hidden" name="step[documents][]" value="#{url}">)
    page.execute_script %(document.querySelector('[data-documents-form]').insertAdjacentHTML('beforeend', '#{input}'))
  end
end
