module PaperworkHelper
  def upload_paperwork(object_name: "step")
    add_paperwork_photo("https://example.com/images/drivers_license.jpg", object_name)
    add_paperwork_photo("https://example.com/images/proof_of_income.jpg", object_name)
  end

  def add_paperwork_photo(url, object_name)
    input = %(<input type="hidden" name="#{object_name}[paperwork][]" value="#{url}">)
    page.execute_script(
      <<~JAVASCRIPT
        document.querySelector('[data-uploadables-form]').
          insertAdjacentHTML('beforeend', '#{input}')
    JAVASCRIPT
    )
  end
end
