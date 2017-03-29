class Views::Steps::HouseholdIntroduction < Views::Base
  def content
    slab_with_card do
      h4 "What are they?", class: "step-section-header__headline"

      list(
        ["Household", "Information about yourself and each person in your household"],
        ["Money & Income", "Information about money you receive and valuable things you may own"],
        ["Expenses", "We will ask about your expenses for things like housing, medicine, dependent care and more"],
        ["Preferences", "We will ask about the best ways to reach you and to proceed with your application, plus any additional information that you might want to share with us."],
      )
    end

    slab_with_card do
      h3 "Next, describe your household for us.", class: "h3--strong"
      help_text <<~TEXT
        If you aren't sure about all the details right now — that's okay. 
        Do your best and we will work with you to clarify later.
      TEXT
    end
  end

  def list(*items)
    ul class: "list--bulleted" do
      items.each do |item|
        li do
          b item.first
          br
          span item.last, class: "text--small"
        end
      end
    end
  end

end
