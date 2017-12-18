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

  def proceed_with(submit_button_text, scroll_to_top: false)
    check_accessibility(scroll_to_top)
    click_on submit_button_text
  end

  def check_accessibility(scroll_to_top)
    expect(page).to be_accessible

    if scroll_to_top
      page.execute_script "window.scrollTo(0,0)"
    end
  end

  def on_page(page_title)
    expect(page.title.strip).to eq page_title
    yield
  end

  def select_job_number(display_name:, job_number:)
    within(".household-member-group[data-member-name='#{display_name}']") do
      select(job_number)
    end
  end

  def click_back
    within(".step-header") do
      find(".icon-arrow_back").click
    end
  end

  alias on_pages on_page
end
